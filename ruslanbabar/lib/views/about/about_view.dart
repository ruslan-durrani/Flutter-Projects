import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ruslanbabar/components/ReviewsSection.dart';
import 'package:ruslanbabar/components/TopSectionHeader.dart';
import 'package:ruslanbabar/models/experience.dart';
import 'package:ruslanbabar/utils/responsive.dart';
import 'package:ruslanbabar/views/about/widgets/education_experience_section.dart';

import '../../components/BioInfoSection.dart';
import '../../components/DetailCard.dart';
import '../../components/CertificationAndStatisticsSection.dart';
import '../../models/education.dart';
import '../../theme.dart';

class AboutView extends StatelessWidget {
  AboutView({super.key});

  List<Widget> sectionWidgets = [
    CertificationAndStatisticsSection(isStatistics: true,),
    BioInfoSection(),
    EducationExperienceSection(),
    CertificationAndStatisticsSection(isStatistics: false,),
  ];
  @override
  Widget build(BuildContext context) {
    final double pad =  28.0;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TopSectionHeader(title: 'About', subtitle: 'Information about your current plan and usages',)
            ],
          ),
          Responsive.isDesktop(context)?
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:  EdgeInsets.symmetric(horizontal: pad),
                width: MediaQuery.of(context).size.width *.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...sectionWidgets.toList()
                  ],
                ),
              ),
              ReviewsSection()
            ],
          ):Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding:  EdgeInsets.symmetric(vertical: pad),
                width: Responsive.isDesktop(context)?MediaQuery.of(context).size.width *.55:double.maxFinite *.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...sectionWidgets.toList()
                  ],
                ),
              ),
              ReviewsSection()
            ],
          ),
        ],
      ),
    );
  }
}
