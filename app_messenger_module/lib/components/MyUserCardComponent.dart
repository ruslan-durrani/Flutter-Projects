import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyUserCardComponent extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData? iconData;
  final String? uid;
  final Function()? onReceiverTap;
  MyUserCardComponent({super.key, required this.title, required this.subTitle, this.iconData=Icons.navigate_next, this.uid="", this.onReceiverTap});

  @override
  Widget build(BuildContext context) {
    print("Future Receivers: "+uid.toString());
    return GestureDetector(
      onTap: onReceiverTap,
      child: Container(
        padding: EdgeInsets.all(20),
        color: Theme.of(context).colorScheme.secondary,
        margin: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.person,size: 40,),
                SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.normal),),
                    Text(subTitle,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,),),
                  ],
                ),
              ],
            ),
            Icon(iconData,size: 30,),
          ],
        ),
      ),
    );
  }
}
