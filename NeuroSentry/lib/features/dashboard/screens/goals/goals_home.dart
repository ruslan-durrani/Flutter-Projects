import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/models/goals_model.dart';
import 'package:mental_healthapp/features/dashboard/screens/goals/goals_detail.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/utils/goals_database.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
import 'package:provider/provider.dart';

import '../../../../shared/utils/get_drawer.dart';

class GoalHomeScreen extends StatefulWidget {
  GoalHomeScreen({Key? key}) : super(key: key);

  @override
  State<GoalHomeScreen> createState() => _GoalHomeScreenState();
}

class _GoalHomeScreenState extends State<GoalHomeScreen> {
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor:  EColors.white,
        key: _scaffoldKey,
        drawer: GetDrawer(),
        appBar: AppBar(
          leading: Container(),
          backgroundColor: EColors.primaryColor,
          centerTitle: true,
          title: Text(
            "GOALS 👋🏻",
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            automaticIndicatorColorAdjustment: true,
            labelStyle: TextStyle(fontWeight: FontWeight.normal,fontSize: 16,color: Colors.white),
            tabs: [
              Tab(icon: Icon(FontAwesomeIcons.award,color: Colors.white,), text: 'My Goals'),
              Tab(icon: Icon(Icons.self_improvement,color: Colors.white), text: 'Want To Improve!'),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add Goal"),
                  content: HelperTextField(
                    controller: controller, // Create a new controller
                    htxt: 'Enter Goal Details',
                    iconData: Icons.add,
                    keyboardType: TextInputType.name,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        final db = Provider.of<GoalDataBase>(context,
                            listen: false);
                        db.saveTask(
                            controller, context); // Call saveTask method
                      },
                      child: const Text("Save"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width *.4,
            height: MediaQuery.of(context).size.width *.2,
            margin: EdgeInsets.only(left: 20,bottom: 20),
            decoration: BoxDecoration(
                color: EColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),  // Adjust opacity for softer shadow
                    blurRadius: 10,  // Blur effect radius
                    offset: Offset(5, 5),  // X, Y offset of shadow
                  ),
                ]
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.add,color: Colors.white,),
                Text("Add Goal",style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              decoration: BoxDecoration(color: EColors.white),
              // padding: EdgeInsets.symmetric(horizontal: 15),
              // margin: EdgeInsets.symmetric(vertical: 10),
              height: MediaQuery.of(context).size.height * .7,

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<GoalDataBase>(
                      builder: (context, db, _) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: ListView.builder(
                            itemCount: db.goals.length,
                            itemBuilder: (context, index) {
                              return GoalTile(
                                title: db.goals[index]['goal'],
                                onCompleted: db.goals[index]['bool'],
                                deleteTask: (context) {
                                  db.deleteTask(
                                    db.goals[index]['goal'],
                                  ); // Call deleteTask method
                                },
                                onChanged: (value) {
                                  db.checkBox(
                                    db.goals[index]['goal'],
                                  ); // Call checkBox method
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView(
                children: [
                  ...List.generate(GoalModel.goalList.length, (index) {
                    List<GoalModel> list = GoalModel.goalList;
                    return CategoryTIle(
                      img: list[index].img,
                      title: list[index].title,
                      goalList: list[index].goals,
                    );
                  }),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

class GoalTile extends StatefulWidget {
  final String title;
  final bool onCompleted;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteTask;

  GoalTile(
      {super.key,
        required this.title,
        required this.onCompleted,
        required this.deleteTask,
        required this.onChanged});

  @override
  State<GoalTile> createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 15, right: 15),
      child: Slidable(
        endActionPane: ActionPane(motion: StretchMotion(), children: [
          SlidableAction(
            onPressed: widget.deleteTask,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade300,
            borderRadius: BorderRadius.circular(10),
          )
        ]),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 162, 233, 236),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Checkbox(
                value: widget.onCompleted,
                onChanged: widget.onChanged,
                activeColor: Colors.black,
              ),
              Container(
                width: MediaQuery.of(context).size.width *.65,
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                      decoration: widget.onCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTIle extends StatelessWidget {
  final String img;
  final String title;
  final List goalList;
  CategoryTIle(
      {super.key,
        required this.img,
        required this.title,
        required this.goalList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      GoalDetails(name: title, img: img, goalList: goalList)));
        },
        child:Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              // color: Colors.white.withOpacity(.1),
              borderRadius: BorderRadius.circular(10)
          ),
          child: ListTile(
            leading: Image.asset(img),
            title: Text(
              title,
              style: TextStyle(
                color: EColors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            trailing: Icon(Icons.arrow_forward,color: Colors.black,),

            tileColor: EColors.secondaryColor, // Assuming secondaryColor is a defined shade in EColors
          ),
        ),

      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mental_healthapp/models/goals_model.dart';
// import 'package:mental_healthapp/features/dashboard/screens/goals/goals_detail.dart';
// import 'package:mental_healthapp/shared/constants/colors.dart';
// import 'package:mental_healthapp/shared/utils/goals_database.dart';
// import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
// import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../shared/utils/get_drawer.dart';
//
// class GoalHomeScreen extends StatefulWidget {
//   GoalHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<GoalHomeScreen> createState() => _GoalHomeScreenState();
// }
//
// class _GoalHomeScreenState extends State<GoalHomeScreen> {
//   TextEditingController controller = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:  EColors.primaryColor,
//       key: _scaffoldKey,
//       drawer: GetDrawer(),
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "GOALS 👋🏻",
//                         style: GoogleFonts.openSans(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Text(
//                         "${DateTime.now().day} ${DateTime.now().month},${DateTime.now().year}",
//                         style: GoogleFonts.openSans(
//                             color: Colors.grey[300], fontSize: 15),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                         color: EColors.primaryColor,
//                         borderRadius: BorderRadius.circular(20)),
//                     child: IconButton(
//                       onPressed: () {
//                         _scaffoldKey.currentState?.openDrawer();
//                       },
//                       icon: Container(
//                         padding: EdgeInsets.all(8),
//                         decoration: BoxDecoration(color: EColors.primaryColor,borderRadius: BorderRadius.circular(5),border: Border.all(width: 2,color: Colors.white)),
//                         child: Icon(
//                           Icons.menu,
//                           color: Colors.white,
//                           size: 30,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Divider(),
//               Container(
//                 decoration: BoxDecoration(color: EColors.primaryColor),
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 height: MediaQuery.of(context).size.height * .7,
//
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Text(
//                           "What area do you want to improve?",
//                           style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.4,
//                         child: Wrap(
//                           direction: Axis.horizontal,
//                           children: List.generate(GoalModel.goalList.length, (index) {
//                             List<GoalModel> list = GoalModel.goalList;
//                             return CategoryTIle(
//                               img: list[index].img,
//                               title: list[index].title,
//                               goalList: list[index].goals,
//                             );
//                           }),
//                         ),
//                       ),
//                       HelperButton(
//                         isPrimary:true,
//                         name: 'Create Your Personalized Goal',
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 title: const Text("Add Goal"),
//                                 content: HelperTextField(
//                                   controller: controller, // Create a new controller
//                                   htxt: 'Enter Goal Details',
//                                   iconData: Icons.add,
//                                   keyboardType: TextInputType.name,
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       final db = Provider.of<GoalDataBase>(context,
//                                           listen: false);
//                                       db.saveTask(
//                                           controller, context); // Call saveTask method
//                                     },
//                                     child: const Text("Save"),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text("Cancel"),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                       ),
//                       Text(
//                         "My Goals:",
//                         style: Theme.of(context).textTheme.headlineMedium,
//                       ),
//                       Consumer<GoalDataBase>(
//                         builder: (context, db, _) {
//                           return SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.4,
//                             child: ListView.builder(
//                               itemCount: db.goals.length,
//                               itemBuilder: (context, index) {
//                                 return GoalTile(
//                                   title: db.goals[index]['goal'],
//                                   onCompleted: db.goals[index]['bool'],
//                                   deleteTask: (context) {
//                                     db.deleteTask(
//                                       db.goals[index]['goal'],
//                                     ); // Call deleteTask method
//                                   },
//                                   onChanged: (value) {
//                                     db.checkBox(
//                                       db.goals[index]['goal'],
//                                     ); // Call checkBox method
//                                   },
//                                 );
//                               },
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class GoalTile extends StatefulWidget {
//   final String title;
//   final bool onCompleted;
//   Function(bool?)? onChanged;
//   Function(BuildContext)? deleteTask;
//
//   GoalTile(
//       {super.key,
//       required this.title,
//       required this.onCompleted,
//       required this.deleteTask,
//       required this.onChanged});
//
//   @override
//   State<GoalTile> createState() => _GoalTileState();
// }
//
// class _GoalTileState extends State<GoalTile> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
//       child: Slidable(
//         endActionPane: ActionPane(motion: StretchMotion(), children: [
//           SlidableAction(
//             onPressed: widget.deleteTask,
//             icon: Icons.delete,
//             backgroundColor: Colors.red.shade300,
//             borderRadius: BorderRadius.circular(10),
//           )
//         ]),
//         child: Container(
//           padding: EdgeInsets.all(15),
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: Color.fromARGB(255, 162, 233, 236),
//               borderRadius: BorderRadius.circular(10)),
//           child: Row(
//             children: [
//               Checkbox(
//                 value: widget.onCompleted,
//                 onChanged: widget.onChanged,
//                 activeColor: Colors.black,
//               ),
//               Text(
//                 widget.title,
//                 style: TextStyle(
//                     decoration: widget.onCompleted
//                         ? TextDecoration.lineThrough
//                         : TextDecoration.none,
//                     fontSize: 18),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CategoryTIle extends StatelessWidget {
//   final String img;
//   final String title;
//   final List goalList;
//   CategoryTIle(
//       {super.key,
//       required this.img,
//       required this.title,
//       required this.goalList});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) =>
//                       GoalDetails(name: title, img: img, goalList: goalList)));
//         },
//         child:Container(
//           padding: EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               // color: Colors.white.withOpacity(.1),
//               borderRadius: BorderRadius.circular(10)
//           ),
//           child: ListTile(
//             leading: Image.asset(img),
//             title: Text(
//               title,
//               style: TextStyle(
//                 color: EColors.black,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             trailing: Icon(Icons.arrow_forward,color: Colors.black,),
//
//             tileColor: EColors.secondaryColor, // Assuming secondaryColor is a defined shade in EColors
//           ),
//         ),
//
//       ),
//     );
//   }
// }
