import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memoir/components/like_button.dart';

class MyListTile extends StatefulWidget {
  String title;
  String subTitle;
  List<String> likes;
  String postId;
  MyListTile({super.key,required this.title,required this.subTitle,required this.likes, required this.postId,});

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isLiked = false;
  final current = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(current!.email)?true:false;
  }
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef = FirebaseFirestore.instance.collection("Memoirs").doc(widget.postId);
    if(isLiked){
      postRef.update({
        "Likes":FieldValue.arrayUnion([current!.email])
      });
    }
    else{
      postRef.update({
      "Likes":FieldValue.arrayRemove([current!.email])
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyLikeButton(onPressLikeButton: toggleLike, isLiked: isLiked,),
              const SizedBox(height: 5,),
              Text(widget.likes.length.toString(),style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),)
            ],
          ),
        ),
        const SizedBox(width: 15,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.subTitle,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary.withOpacity(.5),fontSize: 13),),
            const SizedBox(height: 5,),
            Container(
              width: size.width *.66,
              child: Text(widget.title,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontSize: 14),),
            )

          ],
        )
      ],
    );
  }
}
