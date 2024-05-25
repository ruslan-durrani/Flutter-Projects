import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mental_healthapp/features/auth/controller/profile_controller.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/features/chat/controller/chat_controller.dart';
import 'package:mental_healthapp/features/chat/repository/chat_repository.dart';
import 'package:mental_healthapp/features/chat/screens/chat_user_screen.dart';
import 'package:mental_healthapp/features/dashboard/repository/social_media_repository.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/add_status.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/addpostscreen.dart';
import 'package:mental_healthapp/features/dashboard/screens/socialmedia/comment_screen.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/models/post_model.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';
import 'package:mental_healthapp/shared/constants/utils/helper_textfield.dart';

class BookMarksScreen extends ConsumerStatefulWidget {
  static const routeName = '/social-home';
  const BookMarksScreen({super.key});

  @override
  ConsumerState<BookMarksScreen> createState() => _SocialHomeState();
}

class _SocialHomeState extends ConsumerState<BookMarksScreen> {
  final TextEditingController _postController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        leading: InkWell(
            onTap: ()=>Navigator.pop(context),
            child: Icon(Icons.keyboard_backspace_outlined,color: Colors.white,)),
        title: Text("My Saves",style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FirestorePagination(
                isLive: true,
                query: FirebaseFirestore.instance.collection('posts').where(
                    'postUid',
                    whereIn: ref
                        .read(profileRepositoryProvider)
                        .profile!
                        .bookMarkPosts),
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
                Navigator.of(context).pop();
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


//
// class PostCardWithoutImage extends ConsumerStatefulWidget {
//   const PostCardWithoutImage({
//     super.key,
//     required this.post,
//   });
//   final PostModel post;
//
//   @override
//   ConsumerState<PostCardWithoutImage> createState() =>
//       PostCardWithoutImageState();
// }
//
// class PostCardWithoutImageState extends ConsumerState<PostCardWithoutImage> {
//   Future likeImage() async {
//     if (widget.post.likesProfileUid
//         .contains(FirebaseAuth.instance.currentUser!.uid)) {
//       await ref.read(socialMediaRepositoryProvider).unLikePost(widget.post);
//     } else {
//       await ref.read(socialMediaRepositoryProvider).likePost(widget.post);
//     }
//     setState(() {});
//   }
//
//   Future addPostToBookMarks() async {
//     if (ref
//         .read(profileRepositoryProvider)
//         .profile!
//         .bookMarkPosts
//         .contains(widget.post.postUid)) {
//       await ref.read(socialMediaRepositoryProvider).unBookMarkPost(widget.post);
//     } else {
//       await ref.read(socialMediaRepositoryProvider).bookMarkPost(widget.post);
//     }
//     setState(() {});
//   }
//
//   Future messageUser() async {
//     ChatRoomModel chatRoom = await ref
//         .read(chatControllerProvider)
//         .createOrGetOneToOneChatRoom(widget.post.profileUid, false);
//
//     if (mounted) {
//       Navigator.pushNamed(context, ChatUserScreen.routeName,
//           arguments: [chatRoom]);
//     }
//   }
//
//   Future followAndUnfollowUser() async {
//     if (ref
//         .read(profileRepositoryProvider)
//         .profile!
//         .followingUids
//         .contains(widget.post.profileUid)) {
//       await ref
//           .read(socialMediaRepositoryProvider)
//           .unfollowUser(widget.post.profileUid);
//     } else {
//       await ref
//           .read(socialMediaRepositoryProvider)
//           .followUser(widget.post.profileUid);
//     }
//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }
//
//   void showJoinGroupDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Join Group'),
//           content: const Text('You joined the group.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: EColors.black),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundImage: widget.post.profilePic == null
//                             ? const AssetImage('assets/images/man.png')
//                                 as ImageProvider
//                             : NetworkImage(widget.post.profilePic!),
//                         radius: 20,
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       Text(
//                         widget.post.userName,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             content: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 GestureDetector(
//                                   onTap: followAndUnfollowUser,
//                                   child: ListTile(
//                                     title: Text(ref
//                                             .read(profileRepositoryProvider)
//                                             .profile!
//                                             .followingUids
//                                             .contains(widget.post.profileUid)
//                                         ? "Unfollow"
//                                         : "Follow"),
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                   onTap: messageUser,
//                                   child: const ListTile(
//                                     title: Text("Message"),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     icon: const Icon(Icons.more_vert),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               child: Row(
//                 children: [
//                   const SizedBox(
//                     width: 5,
//                   ),
//                   SizedBox(
//                     width: size.width * 0.8,
//                     child: Text(
//                       widget.post.description,
//                       overflow: TextOverflow.clip,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             widget.post.isGroupShare
//                 ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: ElevatedButton(
//                         style: const ButtonStyle(
//                           minimumSize: MaterialStatePropertyAll(Size(120, 40)),
//                         ),
//                         onPressed: () async {
//                           await ref
//                               .read(chatRepositoryProvider)
//                               .joinGroup(widget.post.groupUid!);
//                           if (context.mounted) {
//                             showJoinGroupDialog(context);
//                           }
//                         },
//                         child: const Text('Join Group'),
//                       ),
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       LikeButtonAndCount(
//                         likeCount: widget.post.likes,
//                         likePost: likeImage,
//                         likeUidList: widget.post.likesProfileUid
//                             .whereType<String>()
//                             .toList(),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       Column(
//                         children: [
//                           IconButton(
//                             onPressed: () => Navigator.pushNamed(
//                               context,
//                               CommentScreen.routeName,
//                               arguments: [
//                                 widget.post,
//                               ],
//                             ),
//                             icon: const Icon(
//                               Icons.chat_bubble_outline,
//                             ),
//                           ),
//                           Text(
//                             widget.post.commentCount.toString(),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     icon: Icon(ref
//                             .read(profileRepositoryProvider)
//                             .profile!
//                             .bookMarkPosts
//                             .contains(widget.post.postUid)
//                         ? Icons.bookmark
//                         : Icons.bookmark_border),
//                     onPressed: addPostToBookMarks,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               child: Text(
//                 '${widget.post.postTime.day}/ ${widget.post.postTime.month} / ${widget.post.postTime.year}',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PostCardWithImage extends ConsumerStatefulWidget {
//   const PostCardWithImage({
//     super.key,
//     required this.post,
//   });
//
//   final PostModel post;
//
//   @override
//   ConsumerState<PostCardWithImage> createState() => _PostCardWithImageState();
// }
//
// class _PostCardWithImageState extends ConsumerState<PostCardWithImage> {
//   Future likeImage() async {
//     if (widget.post.likesProfileUid
//         .contains(FirebaseAuth.instance.currentUser!.uid)) {
//       await ref.read(socialMediaRepositoryProvider).unLikePost(widget.post);
//     } else {
//       await ref.read(socialMediaRepositoryProvider).likePost(widget.post);
//     }
//     setState(() {});
//   }
//
//   Future followAndUnfollowUser() async {
//     if (ref
//         .read(profileRepositoryProvider)
//         .profile!
//         .followingUids
//         .contains(widget.post.profileUid)) {
//       await ref
//           .read(socialMediaRepositoryProvider)
//           .unfollowUser(widget.post.profileUid);
//     } else {
//       await ref
//           .read(socialMediaRepositoryProvider)
//           .followUser(widget.post.profileUid);
//     }
//     if (mounted) {
//       Navigator.pop(context);
//     }
//   }
//
//   Future addPostToBookMarks() async {
//     if (ref
//         .read(profileRepositoryProvider)
//         .profile!
//         .bookMarkPosts
//         .contains(widget.post.postUid)) {
//       await ref.read(socialMediaRepositoryProvider).unBookMarkPost(widget.post);
//     } else {
//       await ref.read(socialMediaRepositoryProvider).bookMarkPost(widget.post);
//     }
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(border: Border.all(color: EColors.black)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(children: [
//                     CircleAvatar(
//                       backgroundImage: widget.post.profilePic == null
//                           ? const AssetImage('assets/images/man.png')
//                               as ImageProvider
//                           : NetworkImage(widget.post.profilePic!),
//                       radius: 20,
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Text(
//                       widget.post.userName,
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                   ]),
//                   IconButton(
//                     onPressed: () {
//                       showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               content: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: followAndUnfollowUser,
//                                     child: ListTile(
//                                       title: Text(ref
//                                               .read(profileRepositoryProvider)
//                                               .profile!
//                                               .followingUids
//                                               .contains(widget.post.profileUid)
//                                           ? "Unfollow"
//                                           : "Follow"),
//                                     ),
//                                   ),
//                                   const ListTile(
//                                     title: Text("Message"),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           });
//                     },
//                     icon: const Icon(Icons.more_vert),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.35,
//               width: double.infinity,
//               child: Image.network(
//                 widget.post.imageUrl!,
//                 fit: BoxFit.contain,
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       LikeButtonAndCount(
//                         likeCount: widget.post.likes,
//                         likePost: likeImage,
//                         likeUidList: widget.post.likesProfileUid
//                             .whereType<String>()
//                             .toList(),
//                       ),
//                       const SizedBox(
//                         width: 20,
//                       ),
//                       Column(
//                         children: [
//                           IconButton(
//                             onPressed: () => Navigator.pushNamed(
//                               context,
//                               CommentScreen.routeName,
//                               arguments: [
//                                 widget.post,
//                               ],
//                             ),
//                             icon: const Icon(
//                               Icons.chat_bubble_outline,
//                             ),
//                           ),
//                           Text(
//                             widget.post.commentCount.toString(),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   IconButton(
//                     icon: Icon(ref
//                             .read(profileRepositoryProvider)
//                             .profile!
//                             .bookMarkPosts
//                             .contains(widget.post.postUid)
//                         ? Icons.bookmark
//                         : Icons.bookmark_border),
//                     onPressed: addPostToBookMarks,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               width: size.width * 0.9,
//               child: Text(
//                 widget.post.description,
//                 overflow: TextOverflow.clip,
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               child: Text(
//                 '${widget.post.postTime.day}/ ${widget.post.postTime.month} / ${widget.post.postTime.year}',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LikeButtonAndCount extends StatelessWidget {
//   LikeButtonAndCount({
//     super.key,
//     required this.likeCount,
//     required this.likePost,
//     required this.likeUidList,
//   });
//   int likeCount;
//   final Function likePost;
//   List<String> likeUidList;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         IconButton(
//           onPressed: () => likePost(),
//           icon: Icon(
//             likeUidList.contains(FirebaseAuth.instance.currentUser!.uid)
//                 ? Icons.favorite
//                 : Icons.favorite_border,
//             color: likeUidList.contains(FirebaseAuth.instance.currentUser!.uid)
//                 ? Colors.pink
//                 : Colors.grey[600],
//           ),
//         ),
//         Text(
//           likeCount.toString(),
//         ),
//       ],
//     );
//   }
// }
