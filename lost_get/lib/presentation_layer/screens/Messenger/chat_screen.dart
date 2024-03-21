
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/Home/item_detail_screen.dart';
import 'package:lost_get/presentation_layer/widgets/text_field.dart';
import '../../../services/chat_system_services/chat_service.dart';
import '../../widgets/message_item.dart';
import '../../widgets/my_text_field.dart';
import 'package:lost_get/models/user_profile.dart';

import '../Add Report/add_report_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chatScreen";
  final Map<String, dynamic> args;

  ChatScreen({Key? key, required this.args}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late UserProfile _userReceiver;
  String? _reportedItemId;
  ReportItemModel? _reportItem;

  @override
  void initState() {
    super.initState();
    _userReceiver = widget.args['userProfile'];
    _reportedItemId = widget.args['reportedItemId'];
    _chatService.markMessagesAsRead(_userReceiver.uid!);
    if (_reportedItemId != null) {
      fetchReportedItemByReportedItemId().then((item) {
        setState(() {
          _reportItem = item; // Set the reported item in the state
        });
      });
    }
  }
  Future<ReportItemModel?> fetchReportedItemByReportedItemId() async {
    // Fetch all documents in the 'reportItem' collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('reportItems').get();

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
        );
      }
    }

    // Return null if no matching document is found
    return null;
  }



  Future<void> _sendMessage({String? imagePath}) async {
    final String receiverId = _userReceiver.uid!;
    if (imagePath != null) {
      await _chatService.sendMessage(receiverId, photoUrl: imagePath);
    } else if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverId, message: _messageController.text, reportedItemId:_reportedItemId);
    }
    _messageController.clear();
  }


  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildModalOption(title: "Camera", icon: Icons.camera_alt, source: ImageSource.camera),
              _buildModalOption(title: "Gallery", icon: Icons.photo_library, source: ImageSource.gallery),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalOption({required String title, required IconData icon, required ImageSource source}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title,style: Theme.of(context).textTheme.titleSmall,),
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
    return StreamBuilder(
      stream: _chatService.getUsersMessage(_userReceiver.uid),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Center(child: Text("Error Occurred",style: Theme.of(context).textTheme.titleSmall,));
        if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

        final messages = snapshot.data?.docs ?? [];
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index];
            return MessageItem(
              isReceiver: messageData["senderId"] == _userReceiver.uid,
              message: messageData["message"],
              photoUrl: messageData["photoUrl"],
              isRead: messageData["isRead"],
            );
          },
        );
      },
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: "Your message",
              controller: _messageController, isObscure: false,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _handleAttachmentPressed,
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("Reported Item ID: ${_reportedItemId}");
    // print("Full Name: ${_userReceiver.fullName}");
    // if(_reportedItemId != null ){
    //   queryReportedItemBasedOnId(_reportedItemId);
    // }
    // else {
    //   // queryChatMetaReprotedItemId(_reportedItemId);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _userAvatar(),
            const SizedBox(width: 20),
            Text(_userReceiver.fullName!,style: Theme.of(context).textTheme.titleMedium ,),
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
                  image: NetworkImage( _reportItem!.imageUrls!.first),
                )
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text( _reportItem!.title.toString() ??'Title Goes here',style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),),
              Text( _reportItem!.description.toString()??'Description goes here',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
              onPressed: () {

              },
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
      backgroundImage: _userReceiver.imgUrl!.isNotEmpty ? NetworkImage(_userReceiver.imgUrl!) : null,
      child: _userReceiver.imgUrl!.isEmpty ? const Icon(Icons.person, size: 30) : null,
      backgroundColor: Colors.white,
      radius: 20,
    );
  }
}
//
// void queryReportedItemBasedOnId(String? reportedItemId) {
//
// }
