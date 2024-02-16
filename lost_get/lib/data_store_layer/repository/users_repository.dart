import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lost_get/data_store_layer/repository/users_base_repository.dart';
import '../../models/user_profile.dart';

class UserRepository extends BaseUsersRepository {
  final FirebaseFirestore _firebaseFirestore;
  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<UserProfile?> getUserDetails(String uid) async {
    late final UserProfile? userData;
    try {
      final snapshot =
          await _firebaseFirestore.collection('users').doc(uid).get();
      userData = UserProfile.fromSnapshot(snapshot);
    } catch (e) {
      return null;
    }
    return userData;
  }

  Future<void> createUserProfile(String uid, UserProfile user) async {
    final userProfileRef = _firebaseFirestore.collection('users');
    await userProfileRef.doc(uid).set(user.toMap());
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> userData) async {
    await _firebaseFirestore.collection('users').doc(uid).update(userData);
  }

  Query<Map<String, dynamic>> isNumberExists(String phoneNumber) {
    return _firebaseFirestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber);
  }

  Future<String> uploadProfileImage(XFile? image) async {
    File imageFile = File(image!.path);
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profileImages/${DateTime.now()}.jpg');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    // Get the download URL of the uploaded image
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<bool> isNewUser(String uid) async {
    final snapshot =
        await _firebaseFirestore.collection('users').doc(uid).get();
    final data = snapshot.data();

    return data == null ? true : false;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Once signed in, return the UserCredential
    return userCredential;
  }
}
