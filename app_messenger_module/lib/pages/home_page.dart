import 'package:app_messenger_module/auth/AuthService.dart';
import 'package:app_messenger_module/components/DrawerItem.dart';
import 'package:app_messenger_module/components/MyTextField.dart';
import 'package:app_messenger_module/pages/settings_page.dart';
import 'package:flutter/material.dart';

import '../components/MyUserCardComponent.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static final routeName = '/home';

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
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
      ),
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
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context,index){
                  return MyUserCardComponent();
                }
                ),
            )
          ],
        )
      )
    );
  }
}
