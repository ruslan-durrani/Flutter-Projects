import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ruslanbabar/theme.dart';
import 'package:ruslanbabar/utils/responsive.dart';

import 'CertificationAndStatisticsCard.dart';

class CertificationAndStatisticsSection extends StatelessWidget {
  final bool isStatistics;
  CertificationAndStatisticsSection({super.key, required this.isStatistics});

  List<Widget> statisticsWidgetList = [
    CertificationAndStatisticsCard(title: 'Projects', subtitle: '23423', iconString: 'document', color: Colors.deepOrange,),
    // Container(height:  30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
    CertificationAndStatisticsCard(title: 'UXUI', subtitle: '234', iconString: 'pen', color: Colors.purpleAccent,),
    //TODO Line in the middle
    // Container(height: 30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
    CertificationAndStatisticsCard(title: 'Flutter', subtitle: '234', iconString: 'flutter', color: Colors.blue,),
    //TODO Line in the middle
    // Container(height: 30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
    CertificationAndStatisticsCard(title: 'Web', subtitle: '234', iconString: 'stack', color: Colors.redAccent,),
    // Container(height: 30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
    CertificationAndStatisticsCard(title: 'Flutter', subtitle: '234', iconString: 'flutter', color: Colors.blue,),
  ];


  List<Widget> certificationsWidgetList = [
    CertificationAndStatisticsCard(title: 'Certified UX Designer', subtitle: 'Google', iconString: 'document', color: Colors.deepOrange,),
    // Container(height:  30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
    CertificationAndStatisticsCard(title: 'Flutter', subtitle: 'Udemy', iconString: 'pen', color: Colors.purpleAccent,),
    //TODO Line in the middle
    // Container(height: 30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
    CertificationAndStatisticsCard(title: 'Django', subtitle: 'Meta', iconString: 'flutter', color: Colors.blue,),
    //TODO Line in the middle
    // Container(height: 30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
    CertificationAndStatisticsCard(title: 'ML DL', subtitle: 'Coursera', iconString: 'stack', color: Colors.redAccent,),
    // Container(height: 30,width: 1,color: themeData.primaryColor.withOpacity(.1),margin: EdgeInsets.symmetric(horizontal: 15),),
  ];
  @override
  Widget build(BuildContext context) {
    final listToRender = isStatistics? statisticsWidgetList:certificationsWidgetList;
    final double pad = 28;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(40),
      margin: EdgeInsets.only(top: pad),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(13)
      ),
      child: Responsive.isDesktop(context)?
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...listToRender.toList()
        ],
      ):Column(

        children: [
          ...listToRender.toList()
        ],
      )
    );
  }
}
