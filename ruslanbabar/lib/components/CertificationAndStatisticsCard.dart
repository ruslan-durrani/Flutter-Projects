import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ruslanbabar/utils/responsive.dart';

class CertificationAndStatisticsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconString;
  final Color color;
  CertificationAndStatisticsCard({super.key, required this.title, required this.subtitle, required this.iconString, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 45,
          height: 45,
          padding: EdgeInsets.all(10),
          margin: Responsive.isDesktop(context)?EdgeInsets.all(0):EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(.3),
            borderRadius: BorderRadius.circular(13),
          ),
          child: SvgPicture.asset(
              "./assets/icons/${iconString}.svg",
              // color: color
          ),
        ),
        SizedBox(width: 10,),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              Text(subtitle,style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),),
            ],
          ),
        )
      ],
    );
  }
}
