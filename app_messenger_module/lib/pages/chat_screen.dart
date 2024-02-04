import 'package:app_messenger_module/components/MessageItem.dart';
import 'package:app_messenger_module/components/MyTextField.dart';
import 'package:app_messenger_module/models/userModel.dart';
import 'package:app_messenger_module/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chatScreen";
  ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late User user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)!.settings.arguments as User;
  }

  Future<void> sendMessage({String? imagePath}) async {
    if (imagePath != null) {
      await _chatService.sendMessage(user.id, photoUrl: imagePath);
    } else {
      await _chatService.sendMessage(user.id, message: messageController.text);
    }
    messageController.clear();
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildModalOption("Camera", Icons.camera_alt, ImageSource.camera),
            _buildModalOption("Gallery", Icons.photo_library, ImageSource.gallery),
          ],
        ),
      ),
    );
  }

  Widget _buildModalOption(String title, IconData icon, ImageSource source) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () async {
        Navigator.pop(context);
        XFile? image = await ImagePicker().pickImage(source: source);
        if (image != null) {
          String? imageUrl = await _chatService.uploadImage(image.path);
          if (imageUrl != null) {
            await sendMessage(imagePath: imageUrl);
          }
        }
      },
    );
  }

  Widget _buildMessages(String receiverId) {
    return StreamBuilder(
      stream: _chatService.getUsersMessage(receiverId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error Occurred"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var messages = snapshot.data.docs;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var messageData = messages[index];
            return MessageItem(
              isReceiver: messageData["senderId"] == receiverId,
              message: messageData["message"],
              photoUrl: messageData["photoUrl"],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(user.name),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.info, color: Colors.grey),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessages(user.id),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hintText: "Your message",
              isObscure: false,
              controller: messageController,
            ),
          ),
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: _handleAttachmentPressed,
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => sendMessage(),
          ),
        ],
      ),
    );
  }
}
