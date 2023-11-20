import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: colorScheme.inversePrimary.withOpacity(.2),
                  radius: 60,
                  child: Icon(Icons.person,size:  60,color: colorScheme.inversePrimary,),
                ),
              ),
              Text(FirebaseAuth.instance.currentUser!.email.toString(),style: TextStyle(color: colorScheme.inversePrimary),)
            ],
          )
        ),
      ),
    );
  }
}
