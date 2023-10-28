import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  String title;
  String subTitle;
  MyListTile({super.key,required this.title,required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
      subtitle: Text(subTitle,style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
    );
  }
}
