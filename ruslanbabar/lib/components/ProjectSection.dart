import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../theme.dart';
import '../utils/responsive.dart';

class ProjectSection extends StatefulWidget {
   ProjectSection({super.key});

  @override
  State<ProjectSection> createState() => _ProjectSectionState();
}

  List<Map<String,dynamic>>uxList=[
    {
      "img":"ux1",
      "title":"Artigence Meta",
      "description":"description goes here",
    },
    {
      "img":"ux2",
      "title":"Finance",
      "description":"description goes here",
    },
    {
      "img":"ux3",
      "title":"Teamify Dashboard",
      "description":"description goes here",
    },
  ];
  List<Map<String,dynamic>>flutterList=[
    {
      "img":"ux1",
      "title":"Flutter Meta",
      "description":"description goes here",
    },
    {
      "img":"ux2",
      "title":"Flutter Finance",
      "description":"description goes here",
    },
    {
      "img":"ux3",
      "title":"Flutter Dashboard",
      "description":"description goes here",
    },
  ];
class _ProjectSectionState extends State<ProjectSection> {
  List<Map<String, dynamic>> filters = [
    {
      "filter": "UX Design",
      "active": true,
      "itemsList": uxList,
    },
    {
      "filter": "Flutter",
      "active": false,
      "itemsList": flutterList,
    },{
      "filter": "Web Design",
      "active": false,
      "itemsList": uxList,
    },

  ];

  List<Map<String,dynamic>> activeList = uxList;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double pad = 28;
    return Container(
      height: Responsive.isDesktop(context)?430:MediaQuery.of(context).size.height,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Projects",style: Theme.of(context).textTheme.displaySmall),
              InkWell(
                onTap: (){},
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: pad*.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("View All",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Text("Lorem Ipsem is a dummy text",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal)),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: pad),
            child: Row(
              children: [
                ...List.generate(filters.length, (index) {
                  final element = filters.elementAt(index);
                  return InkWell(
                    onTap: (){
                      filters.forEach((_element) {
                          _element["active"] = false;
                      });
                      setState(() {
                        filters.elementAt(index)["active"]=true;
                        activeList = filters.elementAt(index)["itemsList"];
                      });
                    },
                    child: Container(
                      padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin:EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                          color: element["active"]? colorScheme.primary:colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: element["active"]? colorScheme.surface:colorScheme.primary,)
                      ),
                      child: Text(element["filter"],style: Theme.of(context).textTheme.bodySmall!.copyWith(color: element["active"]? colorScheme.surface:colorScheme.primary),),
                    ),
                  );
                })
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                ...List.generate(3, (index) => index).map((i) {
                  return Expanded(
                    child: Padding(
                      padding:  EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // margin: EdgeInsets.all(5),
                            height: 200,
                            alignment: Alignment.center,

                            decoration: BoxDecoration(
                            color: Colors.cyan,
                              image: DecorationImage(image: AssetImage("./assets/images/${activeList[i]["img"]}.png"),fit: BoxFit.fill),
                            ),
                            child: Text(i.toString(), style: TextStyle(color: Colors.white)),
                          ),
                          Text("${activeList.elementAt(i)["title"]}",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                          Text("${activeList.elementAt(i)["description"]}",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
