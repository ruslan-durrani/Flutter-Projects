import 'package:flutter/material.dart';
import 'package:ruslanbabar/models/experience.dart';

import '../theme.dart';

class DetailCard extends StatelessWidget {
  final List<dynamic> listOfItems;
  final String title;
  final String subtitle;
  DetailCard({super.key, required this.listOfItems, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final double pad = 28;
    return Container(
      alignment: Alignment.center,
      padding:  EdgeInsets.all( pad),
      // height: MediaQuery.of(context).size.height * .2,
      margin: EdgeInsets.only(top: pad),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(13)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(title,style: Theme.of(context).textTheme.displaySmall),
          Text(subtitle,style: Theme.of(context).textTheme.bodyMedium,),
          Container(width: 30,height: 1,margin:EdgeInsets.symmetric(vertical: pad*.5),color: themeData.primaryColor.withOpacity(.1),),

          ...List.generate(listOfItems.length, (index){
            dynamic item = listOfItems.elementAt(index);
            return Padding(
              padding:  EdgeInsets.symmetric(vertical: pad*.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 5,
                    backgroundColor: index != 0?Colors.blue:Colors.green,
                  ),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.organisation,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),),
                      Text("${item.duration} (${item.length ?? ''})"),
                      // Container(width: 30,height: 1,margin:EdgeInsets.symmetric(vertical: pad*.5),color: themeData.primaryColor.withOpacity(.1),),
                    ],
                  )
                ],
              ),
            );
          })
        ],
      ),
    );
  }
}
