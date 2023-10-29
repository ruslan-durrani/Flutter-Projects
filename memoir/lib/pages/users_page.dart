import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memoir/components/my_list_tile.dart';
import 'package:memoir/helper/helper_functions.dart';

import '../components/my_backButton.dart';

class UserPage extends StatefulWidget {
  static String routeName = "/user_page";
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  void backPress(){
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context,snapshot){
            if(snapshot.hasError){
              displayMessageToUser(context, snapshot.error.toString());
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.inversePrimary,),
              );
            }
            else if(snapshot.hasData){
              final users = snapshot.data!.docs;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50,bottom: 25,left: 15),
                    child: Row(
                      children: [
                        MyBackButton(backPress: backPress,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: users.length,
                        itemBuilder: (context,index){
                        final user = users[index];
                        final username = user["username"];
                        final email = user["email"];
                        return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary.withOpacity(.2)
                          ),
                            child: MyListTile(title: username, subTitle: email));
                        }),
                  ),
                ],
              );
            }
            else{
              return const Center(child: Text("No Data"),);
            }
          }
      ),
    );
  }
}
