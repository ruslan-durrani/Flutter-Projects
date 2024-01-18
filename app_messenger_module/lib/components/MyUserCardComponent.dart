import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyUserCardComponent extends StatelessWidget {
  const MyUserCardComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Text("Ruslan Babar",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.normal),),
                  Text("23 Jan 2023",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,),),
                ],
              ),
            ],
          ),
          Icon(Icons.navigate_next,size: 30,),
        ],
      ),
    );
  }
}
