import 'package:flutter/cupertino.dart';

import '../../components/ProjectSection.dart';
import '../../components/ReviewsSection.dart';
import '../../components/TopSectionHeader.dart';
import '../../utils/responsive.dart';

class ProjectsView extends StatelessWidget {
  ProjectsView({super.key});
  List<Widget> sectionWidgets = [
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
                child: TopSectionHeader(title: 'Projects', subtitle: 'Information about your current plan and usages',),
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
            ],
          ),
        ],
      ),
    );
  }
}
