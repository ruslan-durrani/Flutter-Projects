import 'package:flutter/material.dart';
class MyUserCardComponent extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData? iconData;
  final String? uid;
  final String? imageUrl;
  final Function()? onReceiverTap;
  MyUserCardComponent({super.key, required this.title, required this.subTitle, this.iconData=Icons.navigate_next, this.uid="", this.onReceiverTap, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget ;
    if (imageUrl!.isEmpty){
      avatarWidget = Icon(Icons.person,size: 40,color: Colors.white,);
    }
    else {
      avatarWidget = Container(
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: NetworkImage(imageUrl.toString()),
            )
        ),
      );
    }
    print("Future Receivers: "+uid.toString());
    return GestureDetector(
      onTap: onReceiverTap,
      child: Container(
        padding: EdgeInsets.all(20),
        color: Theme.of(context).colorScheme.primary,
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              leading: avatarWidget,
              title: Text(title,style: TextStyle(color: Theme.of(context).colorScheme.background,fontWeight: FontWeight.normal,fontSize: 14),),
              subtitle: Text(subTitle,style: TextStyle(color: Theme.of(context).colorScheme.background,fontWeight: FontWeight.normal,fontSize: 10)),
              trailing: Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,),
            )

          ],
        ),
      ),
    );
  }
}