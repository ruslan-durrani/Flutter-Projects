import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData iconData;
  final Function()? onTap;
  final String title;
   DrawerItem({super.key, required this.iconData,required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(iconData,size: 25,color: Theme.of(context).colorScheme.primary,),
      title: Text(textAlign:TextAlign.left,title,style: TextStyle(fontWeight: FontWeight.bold,color:Theme.of(context).colorScheme.primary,letterSpacing: 2,fontSize: 15),),
      trailing: Icon(Icons.navigate_next,color: Theme.of(context).colorScheme.primary,),
    );
  }
}
