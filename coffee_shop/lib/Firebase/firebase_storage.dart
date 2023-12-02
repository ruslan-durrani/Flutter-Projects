import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseStorageService instance = FirebaseStorageService._();

  final FirebaseStorage _storage =
  FirebaseStorage.instanceFor(bucket: 'coffeeshop-df780.appspot.com');

  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> downloadUrls = [];
    try {
      for (int i = 0; i < images.length; i++) {
        XFile image = images[i];

        // Extract the file name from the image path
        String imageName = image.path.split('/').last;

        // Convert XFile to Uint8List
        Uint8List imageData = await image.readAsBytes();

        // Get a reference to the location you want to upload to
        Reference ref = _storage.ref().child("coffee_images/$imageName");

        // Upload the data to Firebase Storage
        UploadTask uploadTask = ref.putData(imageData);

        // Await the completion of the upload task
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL of the uploaded file
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        // Add the download URL to the list
        downloadUrls.add(downloadUrl);
      }

      return downloadUrls;
    } on FirebaseException catch (e) {
      print('Error uploading images: ${e.message}');
      print('Error code: ${e.code}');
      print('Server response: ${e.stackTrace}');
      return [];
    } catch (e) {
      print('Unexpected error uploading images: $e');
      return [];
    }
  }

}
