import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus_meet/screens/home/home_screen.dart';

import '../../theme/colours.dart';

class AppNavigator extends StatefulWidget {
  static String routeName = "/navigator";
  AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _page = 0;
  onPageChange(count){
    setState(() {
      _page = count;
    });
  }
  List<Widget> bodyWidgets = [
    Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
      child: HomeScreen(),
    ),
    // Text("Your Home"),
    Text("Your Home"),
    Text("His Home"),
    Text("Your Home"),
    Text("His Home"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: Text("Meet & Chat",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      body: bodyWidgets[_page],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: footerColor,
        enableFeedback: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _page,
        type: BottomNavigationBarType.fixed,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        onTap: onPageChange,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.comment_bank,),
            label: "Meet and Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_clock,),
            label: "Meetings",
          ),
          BottomNavigationBarItem(

            icon: Icon(Icons.person_outline,),
            label: "Contacts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment_bank,),
            label: "Settings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment_bank,),
            label: "Meet and Chat",
          ),
        ],
      ),

    );
  }
}
