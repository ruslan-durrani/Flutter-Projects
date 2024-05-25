import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_button.dart';

class MoodTracker extends StatefulWidget {
  static const routeName = '/mood-tracker';
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  String selectedEmoji = '';
  @override
  Widget build(BuildContext context) {
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

                              Container(
                                width: MediaQuery.of(context).size.width *.8,
                                child: Text(
                                  "Welcome To Mood Tracker!",
                                  style: GoogleFonts.openSans(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
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
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: EColors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mood,color: EColors.primaryColor,size: 40,),
                      SizedBox(width: 20,),
                      Text(
                        "Mood Tracker",
                        style: Theme.of(context).textTheme.headlineSmall,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(

                    'Please select Your Current Mood',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: EColors.textPrimary),
                  ),
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedEmoji = '😕';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(width: 3,color: selectedEmoji == '😕'?EColors.primaryColor:EColors.white)
                            ),
                            child: Text(
                              '😕',
                              style: selectedEmoji == '😕'
                                  ? const TextStyle(fontSize: 50)
                                  : const TextStyle(fontSize: 50),
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmoji = '😃';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(width: 3,color: selectedEmoji == '😃'?EColors.primaryColor:EColors.white)
                          ),
                          child: Text(
                            '😃',
                            style: selectedEmoji == '😃'
                                ? const TextStyle(fontSize: 50)
                                : const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmoji = '😢';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(width: 3,color: selectedEmoji == '😢'?EColors.primaryColor:EColors.white)
                          ),
                          child: Text(
                            '😢',
                            style: selectedEmoji == '😢'
                                ? const TextStyle(fontSize: 50)
                                : const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmoji = '😡';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(width: 3,color: selectedEmoji == '😡'?EColors.primaryColor:EColors.white)
                          ),
                          child: Text(
                            '😡',
                            style: selectedEmoji == '😡'
                                ? const TextStyle(fontSize: 50)
                                : const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEmoji = '😴';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(width: 3,color: selectedEmoji == '😴'?EColors.primaryColor:EColors.white)
                          ),
                          child: Text(
                            '😴',
                            style: selectedEmoji == '😴'
                                ? const TextStyle(fontSize: 50)
                                : const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(

                    'Select words that describe your Mood',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: EColors.textPrimary),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MoodDescriptionTile(
                        title: 'HAPPY',
                      ),
                      MoodDescriptionTile(title: 'DEPRESSED'),
                      MoodDescriptionTile(title: 'ANGRY')
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MoodDescriptionTile(
                        title: 'NERVOUS',
                      ),
                      MoodDescriptionTile(title: 'SAD'),
                      MoodDescriptionTile(title: 'GRATEFUL'),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MoodDescriptionTile(
                        title: 'LONELY',
                      ),
                      MoodDescriptionTile(title: 'EXCITED'),
                      MoodDescriptionTile(title: 'ANNOYED')
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  HelperButton(
                    isPrimary:true,
                    name: 'Submit',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          )
        ]));
  }
}

class MoodDescriptionTile extends StatefulWidget {
  final String title;
  const MoodDescriptionTile({super.key, required this.title});

  @override
  State<MoodDescriptionTile> createState() => _MoodDescriptionTileState();
}

class _MoodDescriptionTileState extends State<MoodDescriptionTile> {
  bool ontap = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          ontap = !ontap;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: ontap ? EColors.primaryColor.withOpacity(.3) : EColors.softGrey,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(widget.title,style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ontap?EColors.primaryColor:Colors.grey.withOpacity(.9)),),
        ),
      ),
    );
  }
}
