import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/global/routes_navigation/models/navigation_model.dart';
import 'package:responsive_admin_dashboard/screens/components/drawer_list_tile.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            // padding: EdgeInsets.only(left:20,top:20,right: appPadding*4,bottom: 20),
            child: Row(children: [
              Image.asset("assets/images/logowithtext.png",scale: 2.5,),
              // Icon(Icons.arrow)
            ],),
          ),
          ...binderList.map((e) => DrawerListTile(
              title: e.navigationItemIcon.values.first,
              svgSrc: e.navigationItemIcon.values.last,
            widget: e.routeScreen
              ),).toList(),
        ],
      ),
    );
  }
}
