import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../components/CertificationAndStatisticsSection.dart';
import '../../components/ReviewsSection.dart';
import '../../components/TopSectionHeader.dart';
import '../../utils/responsive.dart';

class ServicesView extends StatelessWidget {
  const ServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final double pad =  28.0;
    List<Widget> sectionWidgets = [
      CertificationAndStatisticsSection(isStatistics: true,),
    ];
    List<Map<String, dynamic>> services = [
      {
        "service_title":"UX UI",
        "title": "User Experience & User Interface Design",
        "tags":"User Research · Interviews · Information Architecture · Wireframe · UI Design · Prototyping",
        "description":"\nLorem ipsem is a dummy text, use as a smaple to fill up for content. Lorem ipsem is a dummy text. Use as a smaple to fill up for contentLorem ipsem is a Dummy text, use as a smaple to fill up for contentLorem Ipsem is a dummy text, use as a smaple to fill up for Ipsem is a dummy text, use as a smaple to fill up for\n",
        "colorsList":[
          Color(0xFFFF007A), // Pink
          Color(0xFF6A00FF), // Purple
        ]
      },
      {
        "service_title":"MOBILE",
        "title": "Flutter Development",
        "tags":"User Research · Interviews · Information Architecture · Wireframe · UI Design · Prototyping",
        "description":"\nLorem ipsem is a dummy text, use as a smaple to fill up for content. Lorem ipsem is a dummy text. Use as a smaple to fill up for contentLorem ipsem is a Dummy text, use as a smaple to fill up for contentLorem Ipsem is a dummy text, use as a smaple to fill up for Ipsem is a dummy text, use as a smaple to fill up for\n",
        "colorsList":[
          Color(0xFF00D4FF), // Light blue
          Color(0xFF0073FF), // Dark blue
        ]
      },
      {
        "service_title":"WEB",
        "title": "MERN Stack Development",
        "tags":"User Research · Interviews · Information Architecture · Wireframe · UI Design · Prototyping",
        "description":"\nLorem ipsem is a dummy text, use as a smaple to fill up for content. Lorem ipsem is a dummy text. Use as a smaple to fill up for contentLorem ipsem is a Dummy text, use as a smaple to fill up for contentLorem Ipsem is a dummy text, use as a smaple to fill up for Ipsem is a dummy text, use as a smaple to fill up for\n",
        "colorsList":[
          Color(0xFF34e89e), // Green
          Color(0xFF0f3443), // Dark green
        ]
      },
      {
        "service_title":"GFX",
        "title": "Graphics Design",
        "tags":"User Research · Interviews · Information Architecture · Wireframe · UI Design · Prototyping",
        "description":"\nLorem ipsem is a dummy text, use as a smaple to fill up for content. Lorem ipsem is a dummy text. Use as a smaple to fill up for contentLorem ipsem is a Dummy text, use as a smaple to fill up for contentLorem Ipsem is a dummy text, use as a smaple to fill up for Ipsem is a dummy text, use as a smaple to fill up for\n",
        "colorsList":[
          Color(0xFFff6a00), // Orange
          Color(0xFFee0979), // Red
        ]
      }
    ];
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TopSectionHeader(title: 'Services', subtitle: 'Services i am offering',)
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ...List.generate(services.length, (index){
                return ServiceCard(card_title: services[index]["service_title"], tags: services[index]["tags"], title: services[index]["title"], link: 'www.ruslan.com', description: services[index]["description"], colours: services[index]["colorsList"],);
              })
            ],
          )
        ],
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String card_title;
  final String title;
  final String tags;
  final String description;
  final String link;
  final List<Color> colours;
  const ServiceCard( {super.key, required this.card_title, required this.title, required this.tags, required this.link, required this.description, required this.colours});
  @override
  Widget build(BuildContext context) {
  final double pad =  Responsive.isDesktop(context)?28.0:15;
    return Container(
        padding:  EdgeInsets.symmetric(horizontal: pad),
        width: Responsive.isDesktop(context)?MediaQuery.of(context).size.width *.55:MediaQuery.of(context).size.width,
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(pad),
            margin: EdgeInsets.only(top: pad),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(13)
            ),
            child: Responsive.isDesktop(context)?Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1,child: GetTitleCard(context)),
                Expanded(flex: 2,child:GetServiceDetails(context))
              ],
            ):Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetTitleCard(context),
                SizedBox(height: 10,),
                GetServiceDetails(context)
              ],
            )
        ));

  }
  GetServiceDetails(BuildContext context){
    double horizontalPad = Responsive.isDesktop(context)?20:10;
    double verticlePad = Responsive.isDesktop(context)?10:5;
    return Container(
      margin: Responsive.isDesktop(context)?EdgeInsets.only(left: 10):EdgeInsets.only(left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
          Text(tags,style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary.withOpacity(.6)),),
          Text(description,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal,color: Theme.of(context).colorScheme.primary),),
          Row(
            children: [
              Container(
                padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                margin:EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color:  Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  // border: Border.all(color:  colorScheme.surface:colorScheme.primary,)
                ),
                child: Text("View Projects",style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),),),
              Container(
                padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                margin:EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  // color:  Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color:  Theme.of(context).colorScheme.primary,)
                ),
                child: Text("Contact Me",style: TextStyle(color: Colors.black),),),
            ],
          ),

        ],
      ),
    );
  }
  GetTitleCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment:Alignment.centerLeft,
          padding: EdgeInsets.all(50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: colours,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Text(textAlign: TextAlign.center,card_title,style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 32,color: Colors.white,fontWeight: FontWeight.bold),),),
      ],
    );
  }

}
