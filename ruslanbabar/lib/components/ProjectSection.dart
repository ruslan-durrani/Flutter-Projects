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

class _ProjectSectionState extends State<ProjectSection> {
  List<Map<String, dynamic>> filters = [
    {
      "filter": "UX Design",
      "active": true,
    },
    {
      "filter": "Flutter",
      "active": false,
    },{
      "filter": "Web Design",
      "active": false,
    },

  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final double pad = 28;
    return Container(
      height: Responsive.isDesktop(context)?500:MediaQuery.of(context).size.height,
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
          Text("Projects",style: Theme.of(context).textTheme.displaySmall),
          Text("Lorem Ipsem is a dummy text",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal)),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: pad),
            child: Row(
              children: [
                ...List.generate(filters.length, (index) {
                  final element = filters.elementAt(index);
                  return InkWell(
                    onTap: (){
                      print(filters);
                      filters.forEach((_element) {
                          _element["active"] = false;
                      });
                      setState(() {
                        filters.elementAt(index)["active"]=true;
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
                ...List.generate(3, (index) => index + 1).map((i) {
                  return Expanded(
                    child: Padding(
                      padding:  EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              // margin: EdgeInsets.all(5),
                              alignment: Alignment.center,

                              decoration: BoxDecoration(
                              color: Colors.cyan,
                                image: DecorationImage(image: AssetImage("./assets/images/ruslan.png"),fit: BoxFit.fill),
                              ),
                              child: Text(i.toString(), style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Text("Project 1",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                          Text("Lorem Ipsem is a dummy text",style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

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
                      Text("Learn more",style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.deepOrange),),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
