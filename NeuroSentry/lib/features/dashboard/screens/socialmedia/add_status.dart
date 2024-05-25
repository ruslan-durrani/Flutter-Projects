import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/chat/repository/chat_repository.dart';
import 'package:mental_healthapp/features/dashboard/repository/social_media_repository.dart';
import 'package:mental_healthapp/models/post_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddGroupAndShare extends ConsumerStatefulWidget {
  static const routeName = '/add-group-and-share';
  const AddGroupAndShare({super.key});

  @override
  ConsumerState<AddGroupAndShare> createState() => _AddGroupAndShareState();
}

class _AddGroupAndShareState extends ConsumerState<AddGroupAndShare> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _groupNameController = TextEditingController();

  Future createGroupAndPost() async {
    String groupChatUid = const Uuid().v4();

    await ref
        .read(chatRepositoryProvider)
        .createOrGetGroupChatRooms(groupChatUid, _groupNameController.text);

    PostModel post = PostModel(
      postUid: const Uuid().v4(),
      profileUid: FirebaseAuth.instance.currentUser!.uid,
      userName: ref.read(profileRepositoryProvider).profile!.profileName,
      description: _postController.text,
      postTime: DateTime.now(),
      likes: 0,
      commentCount: 0,
      likesProfileUid: [],
      isGroupShare: true,
      groupUid: groupChatUid,
    );

    await ref.read(socialMediaRepositoryProvider).addPost(post);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
    _groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        title: const Text(
          'Add Group Post',
          style: TextStyle(color: EColors.white, fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: createGroupAndPost,
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
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _postController,
              decoration: const InputDecoration(
                hintText: 'Describe The Group ...',
                prefixIcon: Icon(
                  FontAwesomeIcons.pen,
                ),
              ),
              maxLines: 3,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(
                hintText: 'Enter Group Name',
                prefixIcon: Icon(
                  FontAwesomeIcons.pen,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
