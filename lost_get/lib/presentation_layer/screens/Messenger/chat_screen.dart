import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/chat_system_services/chat_service.dart';
import '../../widgets/message_item.dart';
import '../../widgets/my_text_field.dart';
import 'package:lost_get/models/user_profile.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chatScreen";
  final UserProfile userProfile;

  const ChatScreen({Key? key, required this.userProfile}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late UserProfile _userReceiver;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _userReceiver = widget.userProfile;
      _chatService.markMessagesAsRead(_userReceiver.uid!);
  }

  Future<void> _sendMessage({String? imagePath}) async {
    final String receiverId = _userReceiver.uid!;
    if (imagePath != null) {
      await _chatService.sendMessage(receiverId, photoUrl: imagePath);
    } else if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverId, message: _messageController.text);
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
      title: Text(title),
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
        if (snapshot.hasError) return Center(child: Text("Error Occurred"));
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            _userAvatar(),
            const SizedBox(width: 20),
            Text(_userReceiver.fullName!),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Implement action
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
