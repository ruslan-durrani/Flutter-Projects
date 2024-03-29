import 'package:app_messenger_module/components/DrawerItem.dart';
import 'package:app_messenger_module/components/MyTextField.dart';
import 'package:app_messenger_module/pages/chatbot.dart';
import 'package:app_messenger_module/pages/settings_page.dart';
import 'package:app_messenger_module/services/auth/AuthService.dart';
import 'package:app_messenger_module/services/chat/chat_service.dart';
import 'package:app_messenger_module/services/chat/users_service.dart';
import 'package:flutter/material.dart';

import '../components/GetDrawer.dart';
import '../components/MyUserCardComponent.dart';
import '../models/userModel.dart';
import 'chat_screen.dart';
//todo Chat Room Users here only.
class HomePage extends StatefulWidget {
  HomePage({super.key});
  static final routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final UsersService _usersService = UsersService();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
          onPressed:() => Navigator.pushNamed(context, ChatBotScreen.routeName),
        child: const Image(
          height: 40,
            image: AssetImage("./assets/img/bot.png")
        ),
      ),
      resizeToAvoidBottomInset: false,
      drawer: GetDrawer(),
      appBar: AppBar(
        backgroundColor: colorScheme.secondary,
        title: Text("Messages",style: TextStyle(
          color: colorScheme.inversePrimary
        ),
        ),
      ),
      body: Container(
        height: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            Container(
              // flex: 1,
              child: MyTextField(hintText: "Search",trailingIcon: Icons.search, isObscure: true, controller: TextEditingController()),),
            Container(
              height: MediaQuery.of(context).size.height * .7,
              // flex: 5,
              child: _buildStreamHomeUser(),
            )
          ],
        )
      )
    );
  }

  Widget _buildStreamHomeUser() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _usersService.getUserChatsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error Occurred");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // Checking if data is null
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text("No data available");
        }
        // print("Home page snap shot: "+snapshot.toString());

        // Building the ListView if data is available
        return ListView(
          children: snapshot.data!.map<Widget>((userData) {
            User user = User(
                id: userData["uid"],
                name: userData["name"],
                email: userData["email"],
                userChatsList: []
            );
            if(userData["uid"]!=_authService.getCurrentUser()!.uid.toString()) {
              return MyUserCardComponent(title: '${userData["name"]}',subTitle: "${userData["email"]}",iconData: Icons.message,uid: userData["uid"],onReceiverTap: ()=>Navigator.pushNamed(context, ChatScreen.routeName,arguments:user ),);
            }
            return const Text("Hello");
          }).toList(),
        );
      },
    );
  }
}
//