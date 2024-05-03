import 'package:flutter/material.dart';
import 'package:ruslanbabar/utils/responsive.dart';

import '../../../components/DetailCard.dart';
import '../../../models/education.dart';
import '../../../models/experience.dart';

class EducationExperienceSection extends StatelessWidget {
   EducationExperienceSection({super.key});

  List<Widget> widgetsEduExp = [
    Expanded(child: DetailCard(listOfItems: experienceList, title: 'Experience', subtitle: 'Lorem ipsem is a dummy text',)),
    SizedBox(width: 28,),
    Expanded(child: DetailCard(listOfItems: educationList, title: 'Education', subtitle: 'Lorem ipsem is a dummy text',)),

  ];
  @override
  Widget build(BuildContext context) {
    final double pad = 28;
    return Responsive.isDesktop(context)?Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widgetsEduExp.toList(),
      ],
    ):Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...widgetsEduExp.toList(),
      ],
    );
  }
}
