import 'package:flutter/material.dart';
import 'package:nexus_meet/screens/auth/login_screen.dart';
import 'package:nexus_meet/screens/components/home_meeting_button.dart';
import 'package:nexus_meet/theme/colours.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static String routeName = "/home-screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeMeetingButton(onPressed: () {  }, icon: Icons.videocam, text: 'New Meeting',),
            HomeMeetingButton(onPressed: () {  }, icon: Icons.add_box_rounded, text: 'Join meeting',),
            HomeMeetingButton(onPressed: () {  }, icon: Icons.calendar_today, text: 'Schedule',),
            HomeMeetingButton(onPressed: () {  }, icon: Icons.arrow_upward_rounded, text: 'Share Screen',),
          ],
        ),
        Expanded(child: Center(child: Text("Create/Join meeting with a click!",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)))
      ],
    );
  }
}
