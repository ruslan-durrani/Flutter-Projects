import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyUserTile extends StatelessWidget {
  String title;
  String subTitle;
   MyUserTile({super.key,required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Icon(Icons.person,color: Theme.of(context).colorScheme.inversePrimary,),backgroundColor: Theme.of(context).colorScheme.primary,),
      title: Text(title,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontSize: 13),),
      subtitle: Text(subTitle,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary.withOpacity(.5),fontSize: 13),),
    );
  }
}
