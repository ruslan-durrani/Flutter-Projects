import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_healthapp/features/auth/repository/profile_repository.dart';
import 'package:mental_healthapp/models/article_model.dart';
import 'package:mental_healthapp/models/chat_room_model.dart';
import 'package:mental_healthapp/models/comment_model.dart';
import 'package:mental_healthapp/models/post_model.dart';
import 'package:mental_healthapp/models/profile_model.dart';

final socialMediaRepositoryProvider = Provider(
  (ref) => SocialMediaRepository(
      ref: ref, profile: ref.read(profileRepositoryProvider).profile),
);

class SocialMediaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProviderRef ref;
  UserProfile? profile;

  SocialMediaRepository({
    required this.ref,
    required this.profile,
  });

  Stream<List<PostModel>> getPosts() {
    if (profile!.followingUids.isEmpty) {
      return Stream.value([]);
    }
    return _firestore
        .collection('posts')
        .orderBy('postTime', descending: true)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map(
                (e) => PostModel.fromMap(e.data()),
              )
              .toList(),
        );
  }

  Future<String> uploadPostPicture(File file, String postUid) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('posts/$postUid');

    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    // profile!.profilePic = url;
    // await _firestore
    //     .collection('users')
    //     .doc(_auth.currentUser!.uid)
    //     .update(profile!.toMap());
    return url;
  }

  Future followUser(String userId) async {
    profile!.followingCount++;
    profile!.followingUids.add(userId);
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'followingUids': FieldValue.arrayUnion([userId]),
    });
  }

  Future unfollowUser(String userId) async {
    profile!.followingCount--;
    profile!.followingUids.remove(userId);
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'followingUids': FieldValue.arrayRemove([userId]),
    });
  }

  Stream<List<CommentModel>> getCommentsOfPost(PostModel post) {
    return _firestore
        .collection('comments')
        .where('postUid', isEqualTo: post.postUid)
        .orderBy('likes', descending: true)
        .snapshots()
        .map(
          (docsSnapshot) => docsSnapshot.docs
              .map((e) => CommentModel.fromMap(e.data()))
              .toList(),
        );
  }

  Future addPost(PostModel post) async {
    await _firestore.collection('posts').doc(post.postUid).set(
          post.toMap(),
        );
  }

  Future likePost(PostModel post) async {
    post.likes++;
    post.likesProfileUid.add(_auth.currentUser!.uid);
    await _firestore.collection('posts').doc(post.postUid).update(
      {
        'likesProfileUid': FieldValue.arrayUnion([_auth.currentUser!.uid]),
        'likes': FieldValue.increment(1),
      },
    );
  }

  Future unLikePost(PostModel post) async {
    post.likes--;
    post.likesProfileUid.remove(_auth.currentUser!.uid);
    await _firestore.collection('posts').doc(post.postUid).update(
      {
        'likesProfileUid': FieldValue.arrayRemove([_auth.currentUser!.uid]),
        'likes': FieldValue.increment(-1),
      },
    );
  }

  Future addComment(PostModel post, CommentModel comment) async {
    post.commentCount++;

    await _firestore.collection('posts').doc(post.postUid).update(
      {'commentCount': FieldValue.increment(1)},
    );
    await _firestore.collection('comments').doc(comment.commentUid).set(
          comment.toMap(),
        );
  }

  Future likeComment(CommentModel comment) async {
    comment.likes++;
    comment.likesProfileUid.add(_auth.currentUser!.uid);
    await _firestore.collection('comments').doc(comment.commentUid).update(
      {
        'likesProfileUid': FieldValue.arrayUnion([_auth.currentUser!.uid]),
        'likes': FieldValue.increment(1),
      },
    );
  }

  Future unlikeComment(CommentModel comment) async {
    comment.likes--;
    comment.likesProfileUid.remove(_auth.currentUser!.uid);
    await _firestore.collection('comments').doc(comment.commentUid).update(
      {
        'likesProfileUid': FieldValue.arrayRemove([_auth.currentUser!.uid]),
        'likes': FieldValue.increment(-1),
      },
    );
  }

  Future unBookMarkPost(PostModel post) async {
    profile!.bookMarkPosts.remove(post.postUid);
    ref
        .read(profileRepositoryProvider)
        .profile!
        .bookMarkPosts
        .remove(post.postUid);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'bookMarkPosts': FieldValue.arrayRemove([post.postUid]),
    });
  }

  Future bookMarkArticle(String articleTitle) async {
    profile!.bookMarkArticles.add(articleTitle);
    ref
        .read(profileRepositoryProvider)
        .profile!
        .bookMarkPosts
        .add(articleTitle);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'bookMarkPosts': FieldValue.arrayUnion([articleTitle]),
    });
  }

  Future unBookMarkArticles(String articleTitle) async {
    profile!.bookMarkArticles.remove(articleTitle);
    ref
        .read(profileRepositoryProvider)
        .profile!
        .bookMarkPosts
        .remove(articleTitle);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'bookMarkPosts': FieldValue.arrayRemove([articleTitle]),
    });
  }

  Future bookMarkPost(PostModel post) async {
    profile!.bookMarkPosts.add(post.postUid);
    ref
        .read(profileRepositoryProvider)
        .profile!
        .bookMarkPosts
        .add(post.postUid);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'bookMarkPosts': FieldValue.arrayUnion([post.postUid]),
    });
  }

  Stream<List<PostModel>> getBookMarkPosts() {
    return _firestore
        .collection('posts')
        .where('postUid', whereIn: profile!.bookMarkPosts)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.docs
            .map((e) => PostModel.fromMap(e.data()))
            .toList());
  }
}
