import 'package:app_messenger_module/pages/users_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/settings_page.dart';
import '../services/auth/AuthService.dart';
import 'DrawerItem.dart';

class GetDrawer extends StatelessWidget {
  const GetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .8,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(vertical: 60,horizontal: 20),
            child: ListView(
              children: [
                Image(image: AssetImage("./assets/img/msg_logo.png")),
                DrawerItem(iconData: Icons.home_filled, title: "HOME", onTap: ()=>Navigator.pop(context),),
                DrawerItem(iconData: Icons.group, title: "USERS", onTap: ()=>Navigator.pushNamed(context,UserLists.routeName),),
                DrawerItem(iconData: Icons.settings, title: "SETTINGS", onTap: ()=>Navigator.pushNamed(context,SettingsPage.routeName),),
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * .2,
              padding: EdgeInsets.symmetric(vertical: 60,horizontal: 20),
              child: DrawerItem(iconData: Icons.logout, title: "LOGOUT", onTap: AuthService().signOut,)),

        ],
      ),
    );
  }
}
