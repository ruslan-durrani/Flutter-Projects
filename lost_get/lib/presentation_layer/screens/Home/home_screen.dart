import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/models/user_profile.dart';
import 'package:lost_get/services/chat_system_services/chat_service.dart';

import '../../widgets/my_user_component.dart';
import '../ChatBot/chatbot_screen.dart';
import '../Messenger/chat_screen.dart';
import 'components/quick_filter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = "/usersList";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ChatService _chatService = ChatService();
  int _selectedFilterIndex = 0; // The index of the selected filter

  // Define a method to handle filter change
  void _handleFilterChange(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
    // You can also fetch data based on the selected filter here
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset('assets/icons/lostget_logo.svg'), // Replace with your SVG file path
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset('assets/icons/search_icon.svg'), // Replace with your SVG file path
            onPressed: () {
              // Action for search icon
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/notification_icon.svg'), // Replace with your SVG file path
            onPressed: () {
              // Action for notification icon
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/scan_qr_icon.svg'), // Replace with your SVG file path
            onPressed: () {
              // Action for profile icon
            },
          ),
        ],
      ),
      body: Column(
        children: [
          QuickFilterBar(
            onFilterSelected: _handleFilterChange, // Pass the filter change handler
          ),
          Expanded(
            child: _buildBodyContent(), // Build the body content based on the selected filter
          ),
        ],
      ),
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

  Widget _buildBodyContent() {
    // Based on the selected filter index, return different Widgets/content
    switch (_selectedFilterIndex) {
      case 0:
      // This is just an example, replace with your actual content for 'All'
        return Center(child: Text('All selected'));
      case 1:
      // Replace with your actual content for 'Mobile'
        return Center(child: Text('Mobile selected'));
      case 2:
      // Replace with your actual content for 'Cars'
        return Center(child: Text('Cars selected'));
      case 3:
      // Replace with your actual content for 'Wallet'
        return Center(child: Text('Wallet selected'));
      default:
        return Center(child: Text('Content not available'));
    }
  }

}










/*
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
 */