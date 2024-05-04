import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';
import 'DetailCard.dart';

class BioInfoSection extends StatefulWidget {
  const BioInfoSection({super.key});

  @override
  State<BioInfoSection> createState() => _BioInfoSectionState();
}

class _BioInfoSectionState extends State<BioInfoSection> {
  @override
  Widget build(BuildContext context) {
    final double pad = 28;
    return Container(
      alignment: Alignment.center,
      padding:  EdgeInsets.all( pad),
      margin: EdgeInsets.only(top: pad),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.circular(13)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
             CircleAvatar(
               radius: 30,
               backgroundImage: AssetImage("./assets/images/ruslan.png"),
             ),
              SizedBox(width: 10,),
              Column(
                children: [
                  Text("M Ruslan B",style: Theme.of(context).textTheme.displaySmall),
                  Text("Product Developer",style: Theme.of(context).textTheme.bodyMedium,),
                ],
              )
            ],
          ),
          Container(width: 30,height: 1,margin:EdgeInsets.symmetric(vertical: pad*.5),color: themeData.primaryColor.withOpacity(.1),),
          Text("Lorem ispeim is a dummy text add some information about yourslef Lorem ispeim is a dummy text add some information about yourslef Lorem ispeim is a dummy text add some information about yourslef Lorem ispeim is a dummy text add some information about yourslef Lorem ispeim is a dummy text add some information about yourslef",style: Theme.of(context).textTheme.bodyMedium,),
          InkWell(
            onTap: (){

            },
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: pad*.1),
              child: Text("Learn more",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
            ),
          )
        ],
      ),
    );
  }
}
