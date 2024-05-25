import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/dashboard/repository/social_media_repository.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/social_media_home.dart';
import 'package:mental_healthapp/models/comment_model.dart';
import 'package:mental_healthapp/models/post_model.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';
import 'package:uuid/uuid.dart';

class CommentScreen extends ConsumerStatefulWidget {
  static const routeName = '/comment-screen';
  const CommentScreen({
    super.key,
    required this.post,
  });
  final PostModel post;

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();

  Future postComment() async {
    if (_commentController.text != "") {
      final profile = ref.read(profileRepositoryProvider).profile;
      CommentModel comment = CommentModel(
        userName: profile!.profileName,
        commentUid: const Uuid().v4(),
        postUid: widget.post.postUid,
        profileUid: profile.profileId,
        comment: _commentController.text,
        likes: 0,
        likesProfileUid: [],
      );
      await ref
          .read(socialMediaRepositoryProvider)
          .addComment(widget.post, comment);
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirestorePagination(
              query: FirebaseFirestore.instance
                  .collection('comments')
                  .where('postUid', isEqualTo: widget.post.postUid)
                  .orderBy('likes', descending: true),
              isLive: true,
              itemBuilder: (context, snapshot, index) {
                var data = snapshot.data()! as Map<String, dynamic>;
                CommentModel comment = CommentModel.fromMap(data);
                return CommentTile(comment: comment);
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: HelperTextField(
                  htxt: 'Leave A Comment',
                  iconData: FontAwesomeIcons.pen,
                  controller: _commentController,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: postComment,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CommentTile extends ConsumerStatefulWidget {
  const CommentTile({
    super.key,
    required this.comment,
  });
  final CommentModel comment;

  @override
  ConsumerState<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTile> {
  Future likeComment() async {
    if (widget.comment.likesProfileUid
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await ref
          .read(socialMediaRepositoryProvider)
          .unlikeComment(widget.comment);
    } else {
      await ref.read(socialMediaRepositoryProvider).likeComment(widget.comment);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(
        bottom: 20,
        top: 10,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1),
        ),
      ),
      width: size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundImage: widget.comment.profilePic == null
                          ? const AssetImage('assets/images/man.png')
                              as ImageProvider
                          : NetworkImage(widget.comment.profilePic!),
                      radius: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.comment.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child: SizedBox(
                  width: size.width * 0.6,
                  child: Text(
                    widget.comment.comment,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: LikeButtonAndCount(
              likeCount: widget.comment.likes,
              likePost: likeComment,
              likeUidList:
                  widget.comment.likesProfileUid.whereType<String>().toList(),
            ),
          ),
        ],
      ),
    );
  }
}
