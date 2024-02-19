import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lost_get/models/user_profile.dart';
import 'package:lost_get/services/chat_system_services/chat_service.dart';

import '../../widgets/my_user_component.dart';
import '../ChatBot/chatbot_screen.dart';
import '../Messenger/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = "/usersList";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ChatService _chatService = ChatService();
  // final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text("Users"),
      ),
      body: _buildUser(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed:() => Navigator.pushNamed(context, ChatBotScreen.routeName),
        child: const Image(
            height: 40,
            image: AssetImage("./assets/icons/bot.png")
        ),
      ),
    );
  }
  Widget _buildUser(){
    return StreamBuilder(stream: _chatService.getUserStream(), builder: (context,snapshot){
      if(snapshot.hasError){
        return ScaffoldMessenger(child: Container(child: Text("Error Occured"),));
      }
      else if(snapshot.connectionState == ConnectionState.waiting){
        return ScaffoldMessenger(child: Container(child: Text("Loading..."),));
      }
      return ListView(
        children: snapshot.data!.map<Widget>((userData){
          UserProfile userProfile = UserProfile(
              fullName: userData["fullName"],
              email: userData["email"],
              isAdmin: userData["isAdmin"] as bool,
              joinedDateTime: (userData["joinedDateTime"] as Timestamp).toDate(),
              phoneNumber: userData["phoneNumber"],
              biography: userData["biography"],
              preferenceList: userData["preferenceList"] as Map<String, dynamic>,
              imgUrl: userData["imgUrl"],
              dateOfBirth: userData["dateOfBirth"],
              gender: userData["gender"],
              userChatsList: (userData["userChatsList"] as List).map<String>((item) => item as String).toList(),
              uid: userData["uid"]
          );
          return MyUserCardComponent(
            imageUrl: '${userProfile.imgUrl}',
            title: '${userProfile.fullName}',
            subTitle: "${userProfile.email}",
            iconData: Icons.message,
            uid: userData["uid"],
            onReceiverTap: ()=>Navigator.pushNamed(context, ChatScreen.routeName, arguments: userProfile)

          );
          // return Container();
        }).toList(),
      );
    });
  }
}
