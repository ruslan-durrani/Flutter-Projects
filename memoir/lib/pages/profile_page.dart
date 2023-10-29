import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoir/components/my_backButton.dart';
import 'package:memoir/helper/helper_functions.dart';

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
                    const SizedBox(height: 10,),
                    Text(user!["username"],style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),),
                    const SizedBox(height: 10,),
                    Text(user!["email"],style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14
                    ),),
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
