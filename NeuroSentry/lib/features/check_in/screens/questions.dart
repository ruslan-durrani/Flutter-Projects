import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/check_in/controller/check_in_controller.dart';
import 'package:mental_healthapp/models/question_model.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';
import 'package:mental_healthapp/shared/utils/show_snackbar.dart';

class QuestionScreen extends ConsumerStatefulWidget {
  static const routeName = '/question-screen';
  final QuestionType questionType;
   QuestionScreen({
    super.key,
    required this.questionType,
  });
  Map<String,bool> isSelected = {"isQuestionSelected":false};
  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  int totalPoints = 0;
  Future<List<Question>> getQuestionsFromBackend() async {
    return await ref
        .read(checkInControllerProvider)
        .getQuestionsFromQuestionType(widget.questionType);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Questionnaire',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Question>>(
        future: getQuestionsFromBackend(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if data retrieval fails
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the list of questions when data is available
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return QuestionWidget(
                  question: snapshot.data![index],
                  onOptionSelected: (points) {
                    totalPoints += points; // Update total points
                  }, isQuestionSelected: widget.isSelected,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(widget.isSelected["isQuestionSelected"]==false){
            showSnackBar(context: context, content: "Select atleast 1 answer",isError: true);
          }
          else{
            ref
                .read(profileControllerProvider)
                .updateScore(totalPoints, widget.questionType);
            Navigator.pop(context);
          }

        },
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function(int) onOptionSelected;
  Map<String,bool> isQuestionSelected;

   QuestionWidget(
      {super.key, required this.question, required this.onOptionSelected,required this.isQuestionSelected});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with AutomaticKeepAliveClientMixin {
  int? selectedOptionIndex;
  int selectedOptionValue =0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.question.text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.question.options.map((option) {
            int optionIndex = widget.question.options.indexOf(option);
            return RadioListTile(
              title: Text(option.name),
              value: optionIndex,
              groupValue: selectedOptionIndex,
              onChanged: (value) {
                setState(
                  () {
                    widget.isQuestionSelected["isQuestionSelected"] = true;
                    selectedOptionIndex = value as int;
                    widget.onOptionSelected(
                        widget.question.options[value].points -
                            selectedOptionValue);
                    selectedOptionValue = widget.question.options[value].points;
                  },
                );
              },
            );
          }).toList(),
        ),
        const Divider(),
      ],
    );
  }
}

// class QuestionScreen extends ConsumerStatefulWidget {
//   final QuestionType questionType;
//   const QuestionScreen({
//     super.key,
//     required this.questionType,
//   });

//   @override
//   ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
// }

// class _QuestionScreenState extends ConsumerState<QuestionScreen> {
//   PageController _pageController = PageController();
//   final TextEditingController _questionController = TextEditingController();
//   int currIndex = 0;
//   List<Question> questions = [];
//   int points = 0;
//   bool loading = true;

//   @override
//   void initState() {
//     getQuestionsFromBackend();
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return loading
//         ? const LoadingScreen()
//         : Scaffold(
//             appBar: AppBar(
//               backgroundColor: EColors.primaryColor,
//             ),
//             body: Column(
//               children: [
//                 Expanded(
//                     child: PageView.builder(
//                         controller: _pageController,
//                         itemCount: questions.length,
//                         onPageChanged: (index) {
//                           setState(() {
//                             currIndex = index;
//                           });
//                         },
//                         itemBuilder: (context, index) {
//                           return SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 Image.asset(
//                                   questions[index][1],
//                                   height: 150,
//                                   width: 150,
//                                 ),
//                                 const SizedBox(
//                                   height: 15,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(10.0),
//                                   child: Text(
//                                     questions[index][0],
//                                     style:
//                                         Theme.of(context).textTheme.titleLarge,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: TextField(
//                                     controller: _questionController,
//                                     decoration: InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: 'Enter Your Answer',
//                                         fillColor: EColors.softGrey,
//                                         filled: true),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           );
//                         })),
//                 Spacer(),
//                 HelperButton(
//                     name: 'Next',
//                     onTap: () {
//                       responses.add(_questionController.text);
//                       _questionController.clear();
//                       print(responses);
//                       if (currIndex < questions.length - 1) {
//                         _pageController.nextPage(
//                             curve: Curves.easeIn,
//                             duration: const Duration(milliseconds: 300));
//                       } else {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => FinalCheckInReport()));
//                       }
//                     })
//               ],
//             ),
//           );
//   }
// }




















// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Questionnaire App',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: QuestionnaireScreen(),
// //     );
// //   }
// // }

// // class QuestionnaireScreen extends StatefulWidget {
// //   @override
// //   _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
// // }

// // class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
// //   final List<String> questions = [
// //     "How are you feeling today?",
// //     "Have you experienced any stress lately?",
// //     "How well are you sleeping?",
// //     "Do you have any concerns about your mental health?",
// //     "Are you satisfied with your overall well-being?"
// //   ];

// //   int _currentPageIndex = 0;
// //   List<String> responses = [];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Mental Health Questionnaire'),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: PageView.builder(
// //               itemCount: questions.length,
// //               onPageChanged: (index) {
// //                 setState(() {
// //                   _currentPageIndex = index;
// //                 });
// //               },
// //               itemBuilder: (context, index) {
// //                 return QuestionPage(
// //                   question: questions[index],
// //                   onSubmitted: (response) {
// //                     responses.add(response);
// //                     if (index < questions.length - 1) {
// //                       // Move to the next question
// //                       _currentPageIndex++;
// //                     } else {
// //                       // Process the responses or navigate to the next screen
// //                       print(responses);
// //                     }
// //                   },
// //                 );
// //               },
// //             ),
// //           ),
// //           SizedBox(height: 16),
// //           Text(
// //             'Question ${_currentPageIndex + 1} of ${questions.length}',
// //             style: TextStyle(fontSize: 16),
// //           ),
// //           SizedBox(height: 16),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class QuestionPage extends StatelessWidget {
// //   final String question;
// //   final Function(String) onSubmitted;

// //   const QuestionPage({
// //     Key? key,
// //     required this.question,
// //     required this.onSubmitted,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(16.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             question,
// //             style: TextStyle(fontSize: 18),
// //           ),
// //           SizedBox(height: 16),
// //           TextField(
// //             autofocus: true,
// //             onSubmitted: onSubmitted,
// //             decoration: InputDecoration(
// //               hintText: 'Type your answer here',
// //               border: OutlineInputBorder(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
