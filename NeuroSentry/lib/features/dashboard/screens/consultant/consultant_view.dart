// GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       backgroundColor: EColors.primaryColor,
//                                       title: Text(
//                                         'Add Review',
//                                           style: Theme.of(context).textTheme.bodySmall!.copyWith(color: EColors.white),
//                                       ),
//                                       content: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           HelperTextField(
//                                             htxt: 'Give Review',
//                                             iconData: Icons.file_copy,
//                                             controller: _reviewController,
//                                             keyboardType: TextInputType.text,
//                                           ),
//                                           HelperTextField(
//                                             htxt: 'Give Rating',
//                                             iconData: Icons.star_border,
//                                             controller: _ratingController,
//                                             keyboardType: TextInputType.number,
//                                           ),
//                                         ],
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () => addRatingAndReview(),
//                                           child: const Text(
//                                             "Save",
//                                             style:
//                                                 TextStyle(color: EColors.white),
//                                           ),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: const Text(
//                                             "Cancel",
//                                             style:
//                                                 TextStyle(color: EColors.white),
//                                           ),
//                                         )
//                                       ],
//                                     );
//                                   });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: EColors.primaryColor,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Add Review',
//                                   style: TextStyle(
//                                       color: EColors.white, fontSize: 15),
//                                 ),
//                               ),
//                             ),
//                           )
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/features/chat/screens/chat_consultant_screen.dart';
import 'package:mental_healthapp/features/dashboard/repository/dashboard_repository.dart';
import 'package:mental_healthapp/features/dashboard/screens/consultant/book_appointments.dart';
import 'package:mental_healthapp/models/rating_and_review_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';

class ConsultantView extends ConsumerStatefulWidget {
  final String name;
  final String type;
  final String description;
  final List<RatingAndReviewModel> ratings;
  const ConsultantView({
    super.key,
    required this.name,
    required this.type,
    required this.description,
    required this.ratings,
  });

  @override
  ConsumerState<ConsultantView> createState() => _ConsultantViewState();
}

class _ConsultantViewState extends ConsumerState<ConsultantView> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  String _selectedSection = 'About'; // This will hold the currently selected section

  @override
  void dispose() {
    super.dispose();
    _reviewController.dispose();
    _ratingController.dispose();
  }

  int returnAverageRating() {
    double averageRating = 0;
    if (widget.ratings.isEmpty) {
      return 0;
    }
    for (var rating in widget.ratings) {
      averageRating += rating.rating;
    }
    averageRating = averageRating / widget.ratings.length;
    return averageRating.ceil();
  }

  Future addRatingAndReview() async {
    if (_ratingController.text.isNotEmpty && _reviewController.text.isNotEmpty) {
      await ref.read(dashboardRepositoryProvider).updateReviews(
        RatingAndReviewModel(
            userName: ref.read(profileRepositoryProvider).profile!.profileName,
            rating: int.parse(_ratingController.text),
            review: _reviewController.text),
        widget.name,
      );
      _reviewController.clear();
      _ratingController.clear();
      Navigator.pop(context);
    }
  }

  Widget buildSection() {
    switch (_selectedSection) {
      case 'About':
        return Text(
          widget.description,
          style: Theme.of(context).textTheme.bodySmall,
        );
      case 'Ratings':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${returnAverageRating()}/5"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                returnAverageRating(),
                (index) => const Icon(
                Icons.star,
                color: Color.fromRGBO(255, 235, 59, 1),
                ),
                ),
                ),
                ),]),
          ],
        );
      case 'Comments': // For now, both Ratings and Comments will show the same view
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.ratings.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 2,color: EColors.primaryColor.withOpacity(.2))
              ),
              child: ListTile(
                title: Text(widget.ratings[index].userName),
                subtitle: Text(widget.ratings[index].review,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.normal,fontSize: 12),),
                trailing: Text(
                  '${widget.ratings[index].rating > 5 ? 5 : widget.ratings[index].rating}/5',
                ),
              ),
            );
          },
        );
      default:
        return Container(); // Should never be hit.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        leading: InkWell(
            onTap: ()=>Navigator.pop(context),
            child: Icon(Icons.arrow_back_rounded, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(color: EColors.primaryColor),
              child: Column(
                children: [
                  Container(

                    width: double.infinity,
                    decoration: BoxDecoration(color: EColors.primaryColor),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15.0),
                              decoration: const BoxDecoration(
                                color: EColors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FontAwesomeIcons.userDoctor,
                                size: 40,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * .6,
                                    child: Text(
                                      widget.type,
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white,fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(200),
                                    border: Border.all(width: 2,color: Colors.white),
                                    shape: BoxShape.rectangle),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Message",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                                    IconButton(
                                      onPressed: () async {
                                        final chatModel = await ref
                                            .read(chatControllerProvider)
                                            .createOrGetOneToOneChatRoom(widget.name, true);
                                        if (context.mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatConsultantScreen(chatRoom: chatModel),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.chat,color: Colors.white,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: ()=>
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookAppointment(
                                        name: widget.name,
                                        type: widget.type,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                    color: Colors.white,
                                      borderRadius: BorderRadius.circular(30)
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Text("Book Appointment",style: TextStyle(fontSize: 12),),
                                  ),
                                ),
                              ),

                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: EColors.primaryColor,
                                            title: Text(
                                              'Add Review',
                                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: EColors.white),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                HelperTextField(
                                                  htxt: 'Give Review',
                                                  iconData: Icons.file_copy,
                                                  controller: _reviewController,
                                                  keyboardType: TextInputType.text,
                                                ),
                                                HelperTextField(
                                                  htxt: 'Give Rating',
                                                  iconData: Icons.star_border,
                                                  controller: _ratingController,
                                                  keyboardType: TextInputType.number,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => addRatingAndReview(),
                                                child: const Text(
                                                  "Save",
                                                  style:
                                                  TextStyle(color: EColors.white),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style:
                                                  TextStyle(color: EColors.white),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      'Add Review',
                                      style: TextStyle(
                                           fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: ['About', 'Ratings', 'Comments'].map((String section) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    label: Text(section),
                    selected: _selectedSection == section,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedSection = section;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: EColors.primaryColor,
                    labelStyle: TextStyle(color: _selectedSection == section ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildSection(),
            ),
          ],
        ),
      ),
    );
  }
}
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
// import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
// import 'package:mental_healthapp/features/chat/screens/chat_consultant_screen.dart';
// import 'package:mental_healthapp/features/dashboard/repository/dashboard_repository.dart';
// import 'package:mental_healthapp/features/dashboard/screens/consultant/book_appointments.dart';
// import 'package:mental_healthapp/models/rating_and_review_model.dart';
// import 'package:mental_healthapp/shared/constants/colors.dart';
// import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
// import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
//
// class ConsultantView extends ConsumerStatefulWidget {
//   final String name;
//   final String type;
//   final String description;
//   final List<RatingAndReviewModel> ratings;
//   const ConsultantView({
//     super.key,
//     required this.name,
//     required this.type,
//     required this.description,
//     required this.ratings,
//   });
//
//   @override
//   ConsumerState<ConsultantView> createState() => _ConsultantViewState();
// }
//
// class _ConsultantViewState extends ConsumerState<ConsultantView> {
//   final TextEditingController _reviewController = TextEditingController();
//   final TextEditingController _ratingController = TextEditingController();
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _reviewController.dispose();
//     _ratingController.dispose();
//   }
//
//   int returnAverageRating() {
//     double averageRating = 0;
//     if (widget.ratings.isEmpty) {
//       return 0;
//     }
//     for (var rating in widget.ratings) {
//       averageRating += rating.rating;
//     }
//     averageRating = averageRating / widget.ratings.length;
//     if (averageRating > 5) {
//       return 5;
//     }
//     return averageRating.ceil();
//   }
//
//   Future addRatingAndReview() async {
//     if (_ratingController.text.isNotEmpty &&
//         _reviewController.text.isNotEmpty) {
//       await ref.read(dashboardRepositoryProvider).updateReviews(
//             RatingAndReviewModel(
//                 userName:
//                     ref.read(profileRepositoryProvider).profile!.profileName,
//                 rating: int.parse(_ratingController.text),
//                 review: _reviewController.text),
//             widget.name,
//           );
//       _reviewController.clear();
//       _ratingController.clear();
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: EColors.primaryColor,
//         leading: Icon(Icons.arrow_back_rounded,color: Colors.white,),
//       ),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(15.0),
//                 width: double.infinity,
//                 decoration: BoxDecoration(color: EColors.primaryColor),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           padding: EdgeInsets.all(15.0),
//                           decoration: const BoxDecoration(
//                             color: EColors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             FontAwesomeIcons.userDoctor,
//                             size: 60,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 15.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 widget.name,
//                                 style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width * .6,
//                                 child: Text(
//                                   widget.type,
//                                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white,fontSize: 11),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: double.maxFinite,
//                       margin: EdgeInsets.only(top: 10),
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(200),
//                           border: Border.all(width: 2,color: Colors.white),
//                            shape: BoxShape.rectangle),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Message",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
//                           IconButton(
//                             onPressed: () async {
//                               final chatModel = await ref
//                                   .read(chatControllerProvider)
//                                   .createOrGetOneToOneChatRoom(widget.name, true);
//                               if (context.mounted) {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         ChatConsultantScreen(chatRoom: chatModel),
//                                   ),
//                                 );
//                               }
//                             },
//                             icon: const Icon(Icons.chat,color: Colors.white,),
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'About Doctor',
//                         style: Theme.of(context).textTheme.titleLarge!.copyWith(color: EColors.textPrimary),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         widget.description,
//                         style: Theme.of(context).textTheme.bodySmall,
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Text(
//                         "Rating and Review:",
//                         style: Theme.of(context).textTheme.titleLarge!.copyWith(color: EColors.textPrimary),
//                       ),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Row(
//                               children: List.generate(
//                                 returnAverageRating(),
//                                 (index) => const Icon(
//                                   Icons.star,
//                                   color: Color.fromRGBO(255, 235, 59, 1),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               showDialog(
//                                   context: context,
//                                   builder: (context) {
//                                     return AlertDialog(
//                                       backgroundColor: EColors.primaryColor,
//                                       title: Text(
//                                         'Add Review',
//                                           style: Theme.of(context).textTheme.bodySmall!.copyWith(color: EColors.white),
//                                       ),
//                                       content: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           HelperTextField(
//                                             htxt: 'Give Review',
//                                             iconData: Icons.file_copy,
//                                             controller: _reviewController,
//                                             keyboardType: TextInputType.text,
//                                           ),
//                                           HelperTextField(
//                                             htxt: 'Give Rating',
//                                             iconData: Icons.star_border,
//                                             controller: _ratingController,
//                                             keyboardType: TextInputType.number,
//                                           ),
//                                         ],
//                                       ),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () => addRatingAndReview(),
//                                           child: const Text(
//                                             "Save",
//                                             style:
//                                                 TextStyle(color: EColors.white),
//                                           ),
//                                         ),
//                                         TextButton(
//                                           onPressed: () {
//                                             Navigator.pop(context);
//                                           },
//                                           child: const Text(
//                                             "Cancel",
//                                             style:
//                                                 TextStyle(color: EColors.white),
//                                           ),
//                                         )
//                                       ],
//                                     );
//                                   });
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: EColors.primaryColor,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: const Padding(
//                                 padding: EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Add Review',
//                                   style: TextStyle(
//                                       color: EColors.white, fontSize: 15),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 150,
//                         child: ListView.builder(
//                           itemCount: widget.ratings.length,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ListTile(
//                                 title: Text(widget.ratings[index].userName),
//                                 subtitle: Text(widget.ratings[index].review),
//                                 trailing: Text(
//                                   '${widget.ratings[index].rating > 5 ? 5 : widget.ratings[index].rating}/5',
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       )
//
//                     ],
//                   ),
//                 ),
//               ),
//               const Spacer(),
//               HelperButton(
//                   name: "Book Appointment",
//                   isPrimary:true,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => BookAppointment(
//                           name: widget.name,
//                           type: widget.type,
//                         ),
//                       ),
//                     );
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
