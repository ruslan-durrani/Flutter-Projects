import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/features/chat/repository/chat_repository.dart';
import 'package:mental_healthapp/features/chat/screens/chat_user_screen.dart';
import 'package:mental_healthapp/features/dashboard/repository/social_media_repository.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/add_event_screen.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/add_status.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/addpostscreen.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/comment_screen.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/models/post_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/loading.dart';
import 'package:uuid/uuid.dart';

import '../../../chat/screens/message_screen.dart';

class SocialHome extends ConsumerStatefulWidget {
  static const routeName = '/social-home';
  const SocialHome({super.key});

  @override
  ConsumerState<SocialHome> createState() => _SocialHomeState();
}

class _SocialHomeState extends ConsumerState<SocialHome> {
  final TextEditingController _postController = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  Future addPost() async {
    if (_postController.text != "") {
      setState(() {
        isLoading = true;
      });
      String postUid = const Uuid().v4();
      PostModel post = PostModel(
        postUid: postUid,
        profileUid: FirebaseAuth.instance.currentUser!.uid,
        userName: ref.read(profileRepositoryProvider).profile!.profileName,
        description: _postController.text,
        postTime: DateTime.now(),
        likes: 0,
        commentCount: 0,
        likesProfileUid: [],
        profilePic: ref.read(profileRepositoryProvider).profile!.profilePic,
        isGroupShare: false,
      );
      _postController.clear();

      await ref.read(socialMediaRepositoryProvider).addPost(post);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: ref
                                  .read(profileRepositoryProvider)
                                  .profile!
                                  .profilePic ==
                                  null
                                  ? const AssetImage('assets/images/man.png')
                              as ImageProvider
                                  : NetworkImage(
                                ref
                                    .read(profileRepositoryProvider)
                                    .profile!
                                    .profilePic!,
                              ),
                              radius: 20,
                            ),
                            SizedBox(width: 10,),
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${ref
                                    .read(profileRepositoryProvider)
                                    .profile!.profileName}",style: GoogleFonts.openSans().copyWith(fontWeight: FontWeight.bold,fontSize: 16),),
                                Text("What's on your mind",style: GoogleFonts.openSans().copyWith(fontWeight: FontWeight.bold,fontSize: 11),)
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: TextFormField(
                              controller: _postController,
                              onChanged: (query) => setState(() {}),

                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                                fillColor: EColors.primaryColor,
                                filled: false,
                                hintText: 'Share Your Thoughts',
                                hintStyle:
                                 GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.normal,fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),),
                            SizedBox(width: 10,),
                            Container(
                                decoration: BoxDecoration(
                                    color: EColors.secondaryColor.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              child: IconButton(
                                onPressed: () => addPost(),
                                icon:  Icon(
                                  Icons.send,
                                  color: EColors.secondaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: EColors.secondaryColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      color: EColors.secondaryColor,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, AddPostScreen.routeName);
                                      },
                                      icon: const Icon(
                                        Icons.perm_media_outlined,
                                      ),
                                    ),
                                     Text("MEDIA",style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,fontSize: 12),)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: EColors.secondaryColor.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => Navigator.pushNamed(
                                        context,
                                        AddEventScreen.routeName,
                                      ),
                                      icon:  Icon(
                                        Icons.calendar_month,
                                        color: EColors.secondaryColor,
                                      ),
                                    ),
                                    Text("EVENT",style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,fontSize: 12),)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: EColors.secondaryColor.withOpacity(.1),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AddGroupAndShare.routeName,
                                        );
                                      },
                                      icon:  Icon(
                                        Icons.groups_outlined,
                                        color: EColors.secondaryColor,
                                      ),
                                    ),
                                     Text("GROUPS",style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,fontSize: 12),)
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: FirestorePagination(
                      isLive: true,
                      query: FirebaseFirestore.instance
                          .collection('posts')
                          // .where('profileUid',
                          //     isNotEqualTo: FirebaseAuth.instance.currentUser!.uid),
                          .orderBy('postTime', descending: true),
                      itemBuilder: (context, snapshot, index) {
                        final data = snapshot.data() as Map<String, dynamic>;

                        PostModel post = PostModel.fromMap(data);
                        if (post.imageUrl == null) {
                          return PostCardWithoutImage(post: post);
                        } else {
                          return PostCardWithImage(post: post);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class PostCardWithoutImage extends ConsumerStatefulWidget {
  const PostCardWithoutImage({
    super.key,
    required this.post,
  });
  final PostModel post;

  @override
  ConsumerState<PostCardWithoutImage> createState() =>
      PostCardWithoutImageState();
}

class PostCardWithoutImageState extends ConsumerState<PostCardWithoutImage> {
  Future likeImage() async {
    if (widget.post.likesProfileUid
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await ref.read(socialMediaRepositoryProvider).unLikePost(widget.post);
    } else {
      await ref.read(socialMediaRepositoryProvider).likePost(widget.post);
    }
    setState(() {});
  }

  Future addPostToBookMarks() async {
    if (ref
        .read(profileRepositoryProvider)
        .profile!
        .bookMarkPosts
        .contains(widget.post.postUid)) {
      await ref.read(socialMediaRepositoryProvider).unBookMarkPost(widget.post);
    } else {
      await ref.read(socialMediaRepositoryProvider).bookMarkPost(widget.post);
    }
    setState(() {});
  }

  Future messageUser() async {
    ChatRoomModel chatRoom = await ref
        .read(chatControllerProvider)
        .createOrGetOneToOneChatRoom(widget.post.profileUid, false);

    if (mounted) {
      Navigator.pushNamed(context, ChatUserScreen.routeName,
          arguments: [chatRoom]);
    }
  }

  Future followAndUnfollowUser() async {
    if (ref
        .read(profileRepositoryProvider)
        .profile!
        .followingUids
        .contains(widget.post.profileUid)) {
      await ref
          .read(socialMediaRepositoryProvider)
          .unfollowUser(widget.post.profileUid);
    } else {
      await ref
          .read(socialMediaRepositoryProvider)
          .followUser(widget.post.profileUid);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void showJoinGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Join Group'),
          content: const Text('You joined the group.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const MessageScreen(),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,left: 8,right: 8),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),  // Adjust opacity for softer shadow
                blurRadius: 10,  // Blur effect radius
                offset: Offset(5, 5),  // X, Y offset of shadow
              ),
            ]
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: widget.post.profilePic == null
                          ? const AssetImage('assets/images/man.png')
                              as ImageProvider
                          : NetworkImage(widget.post.profilePic!),
                      radius: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: EColors.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 10,),
                            widget.post.isGroupShare
                                ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () async {
                                    await ref
                                        .read(chatRepositoryProvider)
                                        .joinGroup(widget.post.groupUid!);
                                    if (context.mounted) {
                                      showJoinGroupDialog(context);
                                    }
                                  },
                                  child:  Text('Join Group',style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,color: EColors.primaryColor,fontSize: 15,),),
                                ),
                              ),
                            )
                                : const SizedBox.shrink(),
                          ],
                        ),
                        Text(
                          '${widget.post.postTime.day}/${widget.post.postTime.month}/${widget.post.postTime.year}',style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,color: EColors.textSecondary,fontSize: 12,),
                        ),
                      ],
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: followAndUnfollowUser,
                                child: ListTile(
                                  title: Text(ref
                                          .read(profileRepositoryProvider)
                                          .profile!
                                          .followingUids
                                          .contains(widget.post.profileUid)
                                      ? "Unfollow"
                                      : "Follow"),
                                ),
                              ),
                              GestureDetector(
                                onTap: messageUser,
                                child: const ListTile(
                                  title: Text("Message"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            Container(

              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                children: [
                  Container(
                    width: size.width *.8,
                    child: Text(
                      widget.post.description,
                      overflow: TextOverflow.clip,

                      style: GoogleFonts.openSans().copyWith(fontWeight: FontWeight.normal,fontSize: 14,color: EColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeButtonAndCount(
                        likeCount: widget.post.likes,
                        likePost: likeImage,
                        likeUidList: widget.post.likesProfileUid
                            .whereType<String>()
                            .toList(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10,right: 20),
                        decoration: BoxDecoration(
                            color: EColors.secondaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                CommentScreen.routeName,
                                arguments: [
                                  widget.post,
                                ],
                              ),
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                              ),
                            ),
                            Text(
                              widget.post.commentCount.toString(),
                              style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(ref
                            .read(profileRepositoryProvider)
                            .profile!
                            .bookMarkPosts
                            .contains(widget.post.postUid)
                        ? Icons.bookmark
                        : Icons.bookmark_border),
                    onPressed: addPostToBookMarks,
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class PostCardWithImage extends ConsumerStatefulWidget {
  const PostCardWithImage({
    super.key,
    required this.post,
  });

  final PostModel post;

  @override
  ConsumerState<PostCardWithImage> createState() => _PostCardWithImageState();
}

class _PostCardWithImageState extends ConsumerState<PostCardWithImage> {
  Future likeImage() async {
    if (widget.post.likesProfileUid
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      await ref.read(socialMediaRepositoryProvider).unLikePost(widget.post);
    } else {
      await ref.read(socialMediaRepositoryProvider).likePost(widget.post);
    }
    setState(() {});
  }

  Future followAndUnfollowUser() async {
    if (ref
        .read(profileRepositoryProvider)
        .profile!
        .followingUids
        .contains(widget.post.profileUid)) {
      await ref
          .read(socialMediaRepositoryProvider)
          .unfollowUser(widget.post.profileUid);
    } else {
      await ref
          .read(socialMediaRepositoryProvider)
          .followUser(widget.post.profileUid);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future addPostToBookMarks() async {
    if (ref
        .read(profileRepositoryProvider)
        .profile!
        .bookMarkPosts
        .contains(widget.post.postUid)) {
      await ref.read(socialMediaRepositoryProvider).unBookMarkPost(widget.post);
    } else {
      await ref.read(socialMediaRepositoryProvider).bookMarkPost(widget.post);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),  // Adjust opacity for softer shadow
                blurRadius: 10,  // Blur effect radius
                offset: Offset(5, 5),  // X, Y offset of shadow
              ),
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    CircleAvatar(
                      backgroundImage: widget.post.profilePic == null
                          ? const AssetImage('assets/images/man.png')
                              as ImageProvider
                          : NetworkImage(widget.post.profilePic!),
                      radius: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.post.userName,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ]),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: followAndUnfollowUser,
                                    child: ListTile(
                                      title: Text(ref
                                              .read(profileRepositoryProvider)
                                              .profile!
                                              .followingUids
                                              .contains(widget.post.profileUid)
                                          ? "Unfollow"
                                          : "Follow"),
                                    ),
                                  ),
                                  const ListTile(
                                    title: Text("Message"),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: size.width * 0.9,
              child: Text(
                widget.post.description,
                overflow: TextOverflow.clip,
                style: GoogleFonts.openSans().copyWith(fontWeight: FontWeight.normal,fontSize: 14,color: EColors.textPrimary),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              child: Image.network(
                widget.post.imageUrl!,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LikeButtonAndCount(
                        likeCount: widget.post.likes,
                        likePost: likeImage,
                        likeUidList: widget.post.likesProfileUid
                            .whereType<String>()
                            .toList(),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10,right: 20),
                        decoration: BoxDecoration(
                            color: EColors.secondaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                CommentScreen.routeName,
                                arguments: [
                                  widget.post,
                                ],
                              ),
                              icon: const Icon(
                                Icons.chat_bubble_outline,
                              ),
                            ),
                            Text(
                              widget.post.commentCount.toString(),
                              style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(ref
                            .read(profileRepositoryProvider)
                            .profile!
                            .bookMarkPosts
                            .contains(widget.post.postUid)
                        ? Icons.bookmark
                        : Icons.bookmark_border),
                    onPressed: addPostToBookMarks,
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}

class LikeButtonAndCount extends StatelessWidget {
  LikeButtonAndCount({
    super.key,
    required this.likeCount,
    required this.likePost,
    required this.likeUidList,
  });
  int likeCount;
  final Function likePost;
  List<String> likeUidList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 20),
      decoration: BoxDecoration(
          color: EColors.secondaryColor.withOpacity(.1),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => likePost(),
            icon: Icon(
              likeUidList.contains(FirebaseAuth.instance.currentUser!.uid)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: likeUidList.contains(FirebaseAuth.instance.currentUser!.uid)
                  ? Colors.pink
                  : Colors.grey[600],
            ),
          ),
          Text("${likeCount.toString()}",style: GoogleFonts.openSans()!.copyWith(fontWeight: FontWeight.bold,fontSize: 12),)
        ],
      ),
    );

  }
}
