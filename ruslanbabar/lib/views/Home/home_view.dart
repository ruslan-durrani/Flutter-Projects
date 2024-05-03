import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ruslanbabar/components/BioInfoSection.dart';

import '../../components/ProjectSection.dart';
import '../../components/ReviewsSection.dart';
import '../../components/CertificationAndStatisticsSection.dart';
import '../../components/TopSectionHeader.dart';
import '../../utils/responsive.dart';
import '../about/widgets/education_experience_section.dart';
import '../portfolio/widgets/get_persistent_navigator.dart';

class HomeView extends StatelessWidget {
   HomeView({super.key});

  List<Widget> sectionWidgets = [
    CertificationAndStatisticsSection(isStatistics: true,),
    BioInfoSection(),
    ProjectSection(),
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
              Padding(
                padding:  EdgeInsets.only(top: pad,left: pad,right: pad),
                child: TopSectionHeader(title: 'Home', subtitle: 'Information about your current plan and usages',),
              )
            ],
          ),
          Responsive.isDesktop(context)? Row(
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