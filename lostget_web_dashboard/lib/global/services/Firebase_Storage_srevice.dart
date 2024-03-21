import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';

class FirebaseStorageClass {
  final firebase_storage.FirebaseStorage _firebaseStorage;
  FirebaseStorageClass({firebase_storage.FirebaseStorage? firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? firebase_storage.FirebaseStorage.instance;
  Future<void> uploadImage(imageBytes) async {
    try {
      final storageRef = _firebaseStorage.ref().child('profileImages/').child("A.jpg");
      await storageRef.putData(imageBytes);
      print('Image uploaded successfully.');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  Future<String?> getDownloadLink() async {
    try {
      final storageRef = _firebaseStorage.ref().child('profileImages/').child("A.jpg");
      final downloadURL = storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error getting download link: $e');
      return null;
    }
  }
}
