import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/check_in/screens/questions.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';
import 'package:provider/single_child_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'mood_tracker.dart';

class FinalCheckInReport extends ConsumerStatefulWidget {
  static const routename = '/final-check-in-report';
  const FinalCheckInReport({super.key});

  @override
  ConsumerState<FinalCheckInReport> createState() => _FinalCheckInReportState();
}

class _FinalCheckInReportState extends ConsumerState<FinalCheckInReport> {
  bool isMoodDone = false;
  bool isThoughtDone = false;
  bool isSleepDone = false;
  bool isNutritionDone = false;
  List emotionTile = [
    ['Mindset based on mood', 'assets/images/emotion.png'],
    ['My Sleep', 'assets/images/sleep.png'],
    ['Overcome Stress', 'assets/images/fear.png'],
    ['My Nutrition', 'assets/images/diet.png'],
  ];

  Future<int> currentStep() async {
    int stepCount = 0;
    if (ref.read(profileControllerProvider).getScore(QuestionType.mood) !=
        null) {
      stepCount += 25;
      isMoodDone = true;
    }

    if (ref.read(profileControllerProvider).getScore(QuestionType.thoughts) !=
        null) {
      stepCount += 25;
      isThoughtDone = true;
    }

    if (ref.read(profileControllerProvider).getScore(QuestionType.sleep) !=
        null) {
      stepCount += 25;

      isSleepDone = true;
    }

    if (ref.read(profileControllerProvider).getScore(QuestionType.nutrition) !=
        null) {
      stepCount += 25;

      isNutritionDone = true;
    }
    if (stepCount == 100) {
      if (ref.read(profileControllerProvider).isCompletionDateTimeExpired()) {
        await ref
            .read(profileControllerProvider)
            .uploadUserScoreWhenCompleted();
      }
    }

    setState(() {});

    return stepCount;
  }

  @override
  Widget build(BuildContext context) {
    currentStep();
    return Scaffold(
      backgroundColor: EColors.primaryColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
            height: MediaQuery.of(context).size.height *.2,
            decoration:  BoxDecoration(
              color: EColors.primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.arrow_back,color: Colors.white,),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Welcome To Check Ins 👋🏻",
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
                    ],
                  ),
                  Divider(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: EColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              child: Column(
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FutureBuilder<int>(
                        future:
                        currentStep(), // Assuming getCurrentStep is a function that returns a Future<int>
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Show loading indicator while waiting for data
                          } else {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              int currentStep = snapshot
                                  .data!; // Retrieve current step from snapshot data

                              return CircularStepProgressIndicator(
                                height: 140,
                                width: 140,
                                totalSteps: 100,
                                unselectedColor: Colors.grey,
                                selectedColor: EColors.primaryColor,
                                currentStep: currentStep,
                                child: Center(
                                  child: Text(
                                    '${currentStep.toString()}%',
                                    style: const TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Your daily progress!",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 60,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      isMoodDone
                          ? CheckInTile(
                              img: emotionTile[0][1],
                              title: emotionTile[0][0],
                              color: EColors.primaryColor!,
                            )
                          : GestureDetector(
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  QuestionScreen.routeName,
                                  arguments: [QuestionType.mood],
                                );
                                setState(() {
                                   ref
                                  // isMoodDone = ref
                                          .read(profileControllerProvider)
                                          .getScore(QuestionType.mood) !=
                                      null;
                                });
                              },
                              child: CheckInTile(
                                img: emotionTile[0][1],
                                title: emotionTile[0][0],
                                color: EColors.lightGrey,
                              ),
                            ),
                      isSleepDone
                          ? CheckInTile(
                              img: emotionTile[1][1],
                              title: emotionTile[1][0],
                              color: EColors.primaryColor!,
                            )
                          : GestureDetector(
                              onTap: () async {
                                await Navigator.pushNamed(
                                  context,
                                  QuestionScreen.routeName,
                                  arguments: [QuestionType.sleep],
                                );
                                setState(() {
                                   ref
                                  // isMoodDone = ref
                                          .read(profileControllerProvider)
                                          .getScore(QuestionType.sleep) !=
                                      null;
                                });
                              },
                              child: CheckInTile(
                                img: emotionTile[1][1],
                                title: emotionTile[1][0],
                                color: EColors.lightGrey,
                              ),
                            ),
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isThoughtDone
                            ? CheckInTile(
                                img: emotionTile[2][1],
                                title: emotionTile[2][0],
                                color: EColors.primaryColor!,
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    QuestionScreen.routeName,
                                    arguments: [QuestionType.thoughts],
                                  );
                                  setState(() {
                                     ref
                                    // isMoodDone = ref
                                            .read(profileControllerProvider)
                                            .getScore(
                                                QuestionType.thoughts) !=
                                        null;
                                  });
                                },
                                child: CheckInTile(
                                  img: emotionTile[2][1],
                                  title: emotionTile[2][0],
                                  color: EColors.lightGrey,
                                ),
                              ),
                        isNutritionDone
                            ? CheckInTile(
                                img: emotionTile[3][1],
                                title: emotionTile[3][0],
                                color: EColors.primaryColor!,
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    QuestionScreen.routeName,
                                    arguments: [QuestionType.nutrition],
                                  );
                                  setState(() {
                                    // TODO
                                    ref
                                    // isMoodDone = ref
                                            .read(profileControllerProvider)
                                            .getScore(
                                                QuestionType.nutrition) !=
                                        null;
                                  });
                                },
                                child: CheckInTile(
                                  img: emotionTile[3][1],
                                  title: emotionTile[3][0],
                                  color: EColors.lightGrey,
                                ),
                              ),
                      ])
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class CheckInTile extends StatelessWidget {
  final String img;
  final String title;
  final Color color;
  const CheckInTile(
      {super.key, required this.img, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 150,
        // width: 150,
      margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                img,
                height: 50,
                width: 50,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * .4,
                height: MediaQuery.of(context).size.width * .2,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}
