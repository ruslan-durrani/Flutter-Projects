import 'package:app_messenger_module/components/MessageItem.dart';
import 'package:app_messenger_module/components/MyTextField.dart';
import 'package:app_messenger_module/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

import '../models/userModel.dart';

class ChatScreen extends StatefulWidget {
  static String routeName = "/chatScreen";
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController =  TextEditingController();
  final ChatService _chatService = ChatService();
  late User user;

  Future<void> sendMessage() async {
    await _chatService.sendMessage(user.id,message: messageController.text);
  }


  @override
  Widget build(BuildContext context){
    final argsUser = ModalRoute.of(context)!.settings.arguments as User;
    user = argsUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(argsUser.name),
        actions: [
          GestureDetector(
            onTap: (){},
            child: Padding(padding: EdgeInsets.only(right: 20),child: Icon(Icons.info,color: Colors.grey,),),
          )
        ],
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                  child: Container(
                child: _buildMessages(argsUser.id),
              )),
            ],
          )
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(child: MyTextField(hintText: "your message", isObscure: false, controller: messageController)),
            GestureDetector(
              onTap: _handleAttachmentPressed,
              child: Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.attach_file)),
            ),
            GestureDetector(
              onTap: () => sendMessage(),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.send)
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMessages(receiverId){
    return StreamBuilder(stream: _chatService.getUsersMessage(receiverId), builder: (context,snapshot){
      if(snapshot.hasError){
        return ScaffoldMessenger(child: Container(child: Text("Error Occured"),));
      }
      else if(snapshot.connectionState == ConnectionState.waiting){
        return ScaffoldMessenger(child: Container(child: Text("Loading..."),));
      }
      return ListView(
        children: snapshot.data!.docs.map((userData){
         print(userData.data());
          // final msg = userData as Message;
          return Column(
            children: [
              MessageItem(isReceiver: userData["senderId"]==receiverId?true:false, message: userData["message"]),
              // Text(userData["timeStamp"].)
            ],
          );
        }).toList(),
      );
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // _handleImageSelection();
              },
              child:  Align(
                alignment: AlignmentDirectional.centerStart,
                child: ListTile(
                  title: Text("Camera"),
                  subtitle: Text("Capture image using camera"),
                  leading: Icon(Icons.camera_alt_sharp,color: Colors.blue,),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // _handleImageSelection();
              },
              child:  Align(
                alignment: AlignmentDirectional.centerStart,
                child: ListTile(
                  title: Text("Gallery"),
                  subtitle: Text("Select image using camera"),
                  leading: Icon(Icons.image,color: Colors.blue,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
