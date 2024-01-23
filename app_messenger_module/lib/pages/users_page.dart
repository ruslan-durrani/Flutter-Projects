import 'package:app_messenger_module/models/userModel.dart';
import 'package:app_messenger_module/pages/chat_screen.dart';
import 'package:app_messenger_module/services/auth/AuthService.dart';
import 'package:app_messenger_module/services/chat/users_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/MyUserCardComponent.dart';

class UserLists extends StatelessWidget {
  static String routeName = "/usersList";
  UserLists({super.key});
  final UsersService _userService = UsersService();
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: _buildUser(),
    );
  }
  //todo All application Users here.
  Widget _buildUser(){
      return StreamBuilder(stream: _userService.getUserStream(), builder: (context,snapshot){
        if(snapshot.hasError){
          return ScaffoldMessenger(child: Container(child: Text("Error Occured"),));
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return ScaffoldMessenger(child: Container(child: Text("Loading..."),));
        }
        return ListView(
          children: snapshot.data!.map<Widget>((userData){
            User user = new User(id: userData["uid"], name: userData["name"], email: userData["email"], userChatsList: []);
            // if(userData["email"] != _authService.getCurrentUser()!.email)
              return MyUserCardComponent(title: '${userData["name"]}',subTitle: "${userData["email"]}",iconData: Icons.message,uid: userData["uid"],onReceiverTap: ()=>Navigator.pushNamed(context, ChatScreen.routeName,arguments:user ),);
            // return Container();
          }).toList(),
        );
      });
  }
}
