import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir/components/my_backButton.dart';
import 'package:memoir/helper/helper_functions.dart';

import '../components/my_textbox.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = "/profile_page";
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String,dynamic>>> getUserDetails(){
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.email)
        .get();
  }

  void backPress(){
    Navigator.pop(context);
  }

  void onEditButtonPressed(){
    displayMessageToUser(context, "Pressed");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<DocumentSnapshot<Map<String,dynamic>>>(
          future: getUserDetails(),
          builder: (context,snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary,),
              );
            }
            else if(snapshot.hasError){
              return Center(
                child: Text(snapshot.error.toString())
              );
            }
            else if(snapshot.hasData){
              Map<String, dynamic>? user = snapshot.data!.data();
              final username = user!["username"];
              final email = user!["email"];
              final bio = user!["bio"];
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Padding(
                      padding: const EdgeInsets.only(top: 50,left: 15),
                      child: Row(
                        children: [
                          MyBackButton(backPress: backPress,),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25,),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primary
                      ),
                      child: Icon(Icons.person,color: Theme.of(context).colorScheme.inversePrimary,size: 80,),
                    ),
                    const SizedBox(height: 25,),
                     Padding(
                      padding: const EdgeInsets.only(left:15,bottom: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                          child: Text("My Details",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),)),
                    ),
                    MyTextBox(description: username, text: "username",onEditPress: onEditButtonPressed,),
                    MyTextBox(description: bio, text: "bio",onEditPress: onEditButtonPressed,),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:15,bottom: 5),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("My Posts",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),)),
                    ),
                  ],
                ),
              );
            }
            else{
              return const Center(child: Text("No Data"),);
            }
      })
    );
  }
}
