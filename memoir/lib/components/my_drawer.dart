import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memoir/pages/HomePage.dart';
import 'package:memoir/pages/profile_page.dart';
import 'package:memoir/pages/users_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(child: Icon(Icons.favorite,color: Theme.of(context).colorScheme.inversePrimary,)),
              Padding(
                padding: const EdgeInsets.only(left:25.0),
                child: ListTile(
                  leading: Icon(Icons.home_filled,),
                  title: Text("H O M E",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, HomePage.routeName);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:25.0),
                child: ListTile(
                  leading: const Icon(Icons.person,),
                  title: Text("P R O F I L E",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, ProfilePage.routeName);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:25.0),
                child: ListTile(
                  leading: const Icon(Icons.people_alt,),
                  title: Text("U S E R",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, UserPage.routeName);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:25.0,bottom: 25),
            child: ListTile(
              leading: const Icon(Icons.logout,),
              title: Text("L O G O U T",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
              onTap: (){
                logOut();
                Navigator.pop(context);

              },
            ),
          ),
        ],
      )
    );
  }
}
