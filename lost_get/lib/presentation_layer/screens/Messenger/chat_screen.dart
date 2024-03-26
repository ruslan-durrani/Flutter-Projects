import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/utils/api_services.dart';
import 'package:profanity_filter/profanity_filter.dart';
import '../../../services/chat_system_services/chat_service.dart';
import '../../widgets/message_item.dart';
import '../../widgets/my_text_field.dart';
import 'package:lost_get/models/user_profile.dart';

import '../Home/item_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chatScreen";
  final Map<String, dynamic> args;

  const ChatScreen({super.key, required this.args});

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final profanityFilter = ProfanityFilter();
  List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late UserProfile _userReceiver;
  String? _reportedItemId;
  ReportItemModel? _reportItem;

  late final StreamSubscription<QuerySnapshot> _messagesSubscription;



  @override
  void initState() {
    super.initState();
    _userReceiver = widget.args['userProfile'];
    _reportedItemId = widget.args['reportedItemId'];
    _chatService.markMessagesAsRead(_userReceiver.uid!);
    _messagesSubscription = _chatService.getUsersMessage(_userReceiver.uid).listen(
            (QuerySnapshot snapshot) {
          final List<Map<String, dynamic>> messages = snapshot.docs.map((doc) {
            return {
              "id": doc.id,
              ...doc.data() as Map<String, dynamic>,
            };
          }).toList();

          setState(() {
            _messages = messages;
          });
        },
        onError: (error) {
          // Handle any errors
          print("Error fetching messages: $error");
        });


    if (_reportedItemId != null) {
      fetchReportedItemByReportedItemId().then((item) {
        setState(() {
          print(item!.title);
          _reportItem = item;
        });
      });
    }
  }


  @override
  void dispose() {
    _messagesSubscription.cancel(); // Cancel the subscription
    super.dispose();
  }



  Future<ReportItemModel?> fetchReportedItemByReportedItemId() async {
    // Fetch all documents in the 'reportItem' collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('reportItems').get();

    // Iterate through all the documents
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Assuming 'id' is the field in each document you want to compare with reportedItemId
      if (data['id'] == _reportedItemId) {
        // If a match is found, create and return a ReportItemModel from the document
        return ReportItemModel(
            id: doc.id,
            title: data['title'],
            description: data['description'],
            status: data['status'],
            imageUrls: List<String>.from(data['imageUrls']),
            userId: data['userId'],
            category: data['category'],
            subCategory: data['subCategory'],
            publishDateTime: (data['publishDateTime'] as Timestamp).toDate(),
            address: data['address'],
            city: data['city'],
            country: data['country'],
            coordinates: data['coordinates'],
            flagged: data['flagged'],
            published: data['published'],
            recovered: data['recovered']);
      }
    }

    // Return null if no matching document is found
    return null;
  }


  Future<void> _sendMessage({String? imagePath}) async {
    final String receiverId = _userReceiver.uid!;
    _chatService.markMessagesAsRead(_userReceiver.uid!);
    if (imagePath != null) {
      await _chatService.sendMessage(receiverId, photoUrl: imagePath);
    } else if (_messageController.text.isNotEmpty) {
      String tempMessage = _messageController.text;
      bool isProfane = await checkChatProfanity(tempMessage);
      bool hasProfanity = profanityFilter.hasProfanity(tempMessage);
      if (isProfane || hasProfanity) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red), // Icon for the dialog
                  SizedBox(width: 10), // Spacing between icon and text
                  Expanded(child: Text('Profanity Detected')),
                ],
              ),
              content: Text('Your message contains words that violate the rules of our community. Please revise your message to ensure it is appropriate.',style: Theme.of(context).textTheme.bodySmall,),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Understand', style: TextStyle(color: Colors.deepOrange)), // Engaging button label
                ),
              ],
            );
          },
        );
        return; // Stop the function execution if profanity is detected
      }
      _messageController.clear();
      await _chatService.sendMessage(receiverId, message: tempMessage, reportedItemId: _reportedItemId);
    }
  }




  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildModalOption(
                  title: "Camera",
                  icon: Icons.camera_alt,
                  source: ImageSource.camera),
              _buildModalOption(
                  title: "Gallery",
                  icon: Icons.photo_library,
                  source: ImageSource.gallery),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalOption(
      {required String title,
      required IconData icon,
      required ImageSource source}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      onTap: () async {
        Navigator.pop(context);
        final XFile? image = await ImagePicker().pickImage(source: source);
        if (image != null) {
          final String? imageUrl = await _chatService.uploadImage(image.path);
          if (imageUrl != null) {
            await _sendMessage(imagePath: imageUrl);
          }
        }
      },
    );
  }

  Widget _buildMessages() {
    if (_messages.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final messageData = _messages[index];
        return MessageItem(
          isReceiver: messageData["senderId"] == _userReceiver.uid,
          message: messageData["message"],
          photoUrl: messageData["photoUrl"],
          isRead: messageData["isRead"],
        );
      },
    );
  }


  Widget _buildMessageInputField() {
    return Container(
      color: Colors.white,
      height: 35.h,
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: "Your message",
              controller: _messageController,
              isObscure: false,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file, color: AppColors.primaryColor,),
            onPressed: _handleAttachmentPressed,
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColors.primaryColor),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white,),
              onPressed: () => _sendMessage(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String placeholderImageUrl = "https://via.placeholder.com/150";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            _userAvatar(),
            const SizedBox(width: 20),
            Text(
              _userReceiver.fullName!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        // appBar: createAppBar(context, _userReceiver.fullName!),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Implement action
            },
          ),
        ],
      ),
      body: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                _reportItem != null && _reportItem!.imageUrls != null && _reportItem!.imageUrls!.isNotEmpty
                    ? _reportItem!.imageUrls!.first
                    : placeholderImageUrl,
              ),
            )),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _reportItem?.title ?? "Title",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
              Text(
                _reportItem?.description ?? "description",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios_sharp,
                color: Colors.white,
              ),
              onPressed: ()=> Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: _reportItem),
              // onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessages()),
            _buildMessageInputField(),
          ],
        ),
      ),
    );
  }

  Widget _userAvatar() {
    return CircleAvatar(
      backgroundImage: _userReceiver.imgUrl!.isNotEmpty
          ? NetworkImage(_userReceiver.imgUrl!)
          : null,
      backgroundColor: Colors.white,
      radius: 20,
      child: _userReceiver.imgUrl!.isEmpty
          ? const Icon(Icons.person, size: 30)
          : null,
    );
  }
}
