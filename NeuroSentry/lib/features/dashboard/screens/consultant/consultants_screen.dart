import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/dashboard/controller/dashboard_controller.dart';
import 'package:mental_healthapp/models/consultant_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';

import '../../../../shared/utils/get_drawer.dart';
import 'consultant_view.dart';

class ConsultScreen extends ConsumerStatefulWidget {
  const ConsultScreen({super.key});

  @override
  ConsumerState<ConsultScreen> createState() => _ConsultScreenState();
}

class _ConsultScreenState extends ConsumerState<ConsultScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _filterType; // To store the current filter type

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Consultant Type"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
            'Psychiatrist:',
            'Counselor',
            'Marriage and Family Therapist',
            'Neuropsychologist',
            'Psychoanalyst',
            'Substance Abuse Counselor',
            'Child and Adolescent Psychiatrists/Psychologist',
            'Geropsychologist',
            'Behavioral Therapist',
            'Forensic Psychologist',
            'Rehabilitation Psychologist',
            'Health Psychologist',
            'Psychiatrist', 'Psychologist', 'Therapist', 'Counselor'
              ]
                  .map((type) => ListTile(
                title: Text(type),
                onTap: () {
                  setState(() {
                    _filterType = type;
                  });
                  Navigator.of(context).pop();
                },
              ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _clearFilter() {
    setState(() {
      _filterType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: GetDrawer(),
      backgroundColor: EColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: EColors.primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi ${ref.read(profileControllerProvider).getProfileName()} 👋🏻",
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${DateTime.now().day} ${DateTime.now().month},${DateTime.now().year}",
                              style: GoogleFonts.openSans(
                                  color: Colors.grey[300], fontSize: 15),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: _filterType == null ? _showFilterDialog : _clearFilter,
                          icon: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: _filterType == null ? Colors.white : Colors.red,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 2, color: Colors.white)),
                            child: Icon(
                              _filterType == null ? Icons.filter_alt_rounded : Icons.close,
                              color: _filterType == null ?EColors.primaryColor:EColors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            onChanged: (query) => setState(() {}),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              fillColor: EColors.primaryColor,
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                              hintText: 'Search',
                              hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                      color: Colors.grey[100]),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        child: StreamBuilder<List<ConsultantModel>>(
                          stream: ref
                              .read(dashboardControllerProvider)
                              .getConsultantsFromFirebase(
                            _searchController.text.trim(),
                            filter: _filterType,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<ConsultantModel> consultants = snapshot.data ?? [];
                              return ListView.builder(
                                itemCount: consultants.length,
                                itemBuilder: (context, index) {
                                  ConsultantModel consultant = consultants[index];
                                  return GestureDetector(
                                    onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConsultantView(
                                              ratings:
                                                  consultant.ratingsAndReview,
                                              name: consultant.name,
                                              type: consultant.type,
                                              description:
                                                  consultant.description,
                                            ),
                                          ),
                                        );
                                      },
                                    child: ConsultantTile(
                                      title: consultant.name,
                                      subTitle: consultant.type,
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConsultantTile extends StatelessWidget {
  final Color color;
  final String title;
  final String subTitle;

  const ConsultantTile({
    super.key,
    this.color = Colors.blue,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: color),
            child: Icon(
              FontAwesomeIcons.userTie,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: EColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subTitle,
            style: GoogleFonts.openSans(
                color: EColors.textPrimary, fontSize: 12),
          ),
          trailing: Icon(Icons.arrow_forward, color: EColors.textPrimary,),
          tileColor: EColors.secondaryColor, // Assuming secondaryColor is a defined shade in EColors
        ),
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
// import 'package:mental_healthapp/features/chat/screens/message_screen.dart';
// import 'package:mental_healthapp/features/dashboard/controller/dashboard_controller.dart';
// import 'package:mental_healthapp/models/consultant_model.dart';
// import 'package:mental_healthapp/features/dashboard/screens/consultant/consultant_view.dart';
// import 'package:mental_healthapp/shared/constants/colors.dart';
//
// import '../../../../shared/utils/get_drawer.dart';
//
// class ConsultScreen extends ConsumerStatefulWidget {
//   const ConsultScreen({super.key});
//
//   @override
//   ConsumerState<ConsultScreen> createState() => _ConsultScreenState();
// }
//
// class _ConsultScreenState extends ConsumerState<ConsultScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: GetDrawer(),
//       backgroundColor: EColors.primaryColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(color: EColors.primaryColor),
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Hi ${ref.read(profileControllerProvider).getProfileName()} 👋🏻",
//                               style: GoogleFonts.openSans(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Text(
//                               "${DateTime.now().day} ${DateTime.now().month},${DateTime.now().year}",
//                               style: GoogleFonts.openSans(
//                                   color: Colors.grey[300], fontSize: 15),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                               color: EColors.primaryColor,
//                               borderRadius: BorderRadius.circular(20)),
//                           child: IconButton(
//                             onPressed: () {
//                               _scaffoldKey.currentState?.openDrawer();
//                             },
//                             icon: Container(
//                               padding: EdgeInsets.all(8),
//                               decoration: BoxDecoration(color: EColors.primaryColor,borderRadius: BorderRadius.circular(5),border: Border.all(width: 2,color: Colors.white)),
//                               child: Icon(
//                                 Icons.menu,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             controller: _searchController,
//                             onChanged: (query) => setState(() {}),
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
//                               fillColor: EColors.primaryColor,
//                               filled: true,
//                               prefixIcon: const Icon(
//                                 Icons.search,
//                                 color: Colors.white,
//                                 size: 30,
//                               ),
//                               hintText: 'Search',
//                               hintStyle:
//                               const TextStyle(color: Colors.white, fontSize: 14),
//                               border: OutlineInputBorder(
//
//                                 borderRadius: BorderRadius.circular(100),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(left: 4),
//                           padding: EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                             child: Icon(Icons.filter_alt_rounded,color: EColors.primaryColor,))
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Container(
//                   decoration: BoxDecoration(
//                       borderRadius: const BorderRadius.only(
//                         topRight: Radius.circular(20),
//                         topLeft: Radius.circular(20),
//                       ),
//                       color: Colors.grey[100]),
//                   child: Column(
//                     children: [
//                       ConstrainedBox(
//                           constraints: BoxConstraints(
//                             // minHeight: 200,
//                             maxHeight:
//                                 MediaQuery.of(context).size.height * 0.8,
//                           ),
//                           child: StreamBuilder<List<ConsultantModel>>(
//                             stream: ref
//                                 .read(dashboardControllerProvider)
//                                 .getConsultantsFromFirebase(
//                                   _searchController.text.trim(),
//                                 ),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return const Center(
//                                     child: CircularProgressIndicator());
//                               } else if (snapshot.hasError) {
//                                 return Text('Error: ${snapshot.error}');
//                               } else {
//                                 List<ConsultantModel> consultants =
//                                     snapshot.data ?? [];
//                                 return ListView.builder(
//                                   itemCount: consultants.length,
//                                   itemBuilder: (context, index) {
//                                     ConsultantModel consultant =
//                                         consultants[index];
//                                     return GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 ConsultantView(
//                                               ratings:
//                                                   consultant.ratingsAndReview,
//                                               name: consultant.name,
//                                               type: consultant.type,
//                                               description:
//                                                   consultant.description,
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                       child: ConsultantTile(
//                                         title: consultant.name,
//                                         subTitle: consultant.type,
//                                       ),
//                                     );
//                                   },
//                                 );
//                               }
//                             },
//                           )),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ConsultantTile extends StatelessWidget {
//   final Color color;
//   final String title;
//   final String subTitle;
//
//   const ConsultantTile({
//     super.key,
//     this.color = Colors.blue,
//     required this.title,
//     required this.subTitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
//       child: Container(
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10)
//         ),
//         child: ListTile(
//           leading: Container(
//             padding: EdgeInsets.all(15),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: color
//               // color: Colors.blue
//             ),
//             child: Icon(
//               FontAwesomeIcons.userTie,
//               color: Colors.white,
//               size: 30,
//             ),
//           ),
//           title: Text(
//             title,
//             style: TextStyle(
//               color: EColors.textPrimary,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           subtitle: Text(
//             subTitle,
//             style: GoogleFonts.openSans(
//                 color: EColors.textPrimary, fontSize: 12),
//           ),
//           trailing: Icon(Icons.arrow_forward,color: EColors.textPrimary,),
//
//           tileColor: EColors.secondaryColor, // Assuming secondaryColor is a defined shade in EColors
//         ),
//       ),
//     );
//   }
// }
