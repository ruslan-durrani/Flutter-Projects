import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/dashboard/repository/social_media_repository.dart';
import 'package:mental_healthapp/models/post_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/loading.dart';
import 'package:mental_healthapp/shared/utils/pick_image.dart';
import 'package:uuid/uuid.dart';

class AddEventScreen extends ConsumerStatefulWidget {
  static const routeName = '/add-event';
  const AddEventScreen({super.key});

  @override
  ConsumerState<AddEventScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddEventScreen> {
  TextEditingController desController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();

  Future addPost() async {
    if (desController.text.isNotEmpty && dateTimeController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      String eventDescriptionString = """Event at ${dateTimeController.text}

      Event Description : ${desController.text}""";
      String postUid = const Uuid().v4();
      PostModel post = PostModel(
        postUid: postUid,
        profileUid: FirebaseAuth.instance.currentUser!.uid,
        userName: ref.read(profileRepositoryProvider).profile!.profileName,
        description: eventDescriptionString,
        postTime: DateTime.now(),
        likes: 0,
        commentCount: 0,
        likesProfileUid: [],
        profilePic: ref.read(profileRepositoryProvider).profile!.profilePic,
        isGroupShare: false,
      );
      desController.clear();

      await ref.read(socialMediaRepositoryProvider).addPost(post);

      setState(() {
        isLoading = false;
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateTimeController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: EColors.primaryColor,
              actions: [
                TextButton(
                  onPressed: addPost,
                  child: const Text(
                    "POST",
                    style: TextStyle(color: EColors.white),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select event date';
                      }
                      return null; // Return null if the input is valid
                    },
                    controller: dateTimeController,
                    readOnly: true,
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: const InputDecoration(
                      hintText: "Select Event Date",
                      fillColor: EColors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_month_outlined),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage: ref
                                      .read(profileRepositoryProvider)
                                      .profile!
                                      .profilePic ==
                                  null
                              ? const AssetImage('assets/images/man.png')
                                  as ImageProvider
                              : NetworkImage(ref
                                  .read(profileRepositoryProvider)
                                  .profile!
                                  .profilePic!),
                          radius: 20,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: desController,
                          decoration: const InputDecoration(
                              hintText: 'Write about Event',
                              border: InputBorder.none),
                          maxLines: 8,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
