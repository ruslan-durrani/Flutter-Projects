import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:lost_get/models/report_item.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:lost_get/data_store_layer/repository/users_base_repository.dart';

class ReportItemRepository extends BaseUsersRepository {
  final FirebaseFirestore _firebaseFirestore;

  ReportItemRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<String>> uploadImages(List<XFile> imageFiles) async {
    List<String> imageUrls = [];

    for (XFile imageFile in imageFiles) {
      String fileName = p.basename(imageFile.path);
      File file = File(imageFile.path);
      Reference ref =
          FirebaseStorage.instance.ref().child('reportedItems').child(fileName);
      UploadTask uploadTask = ref.putFile(file);
      await uploadTask.whenComplete(() async {
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      });
    }

    return imageUrls;
  }

  Future<bool> publishReport(ReportItemModel reportItem) async {
    try {
      final reportItemRef = _firebaseFirestore.collection('reportItems');
      await reportItemRef.add(reportItem.toMap());
      // Handle successful addition if needed
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ReportItemModel>> getUserReports() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final snapshot = await _firebaseFirestore
          .collection('reportItems')
          .where('userId', isEqualTo: uid)
          .get();

      // Convert the query snapshot to a list of ReportItemModel
      final List<ReportItemModel> reports = snapshot.docs
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .toList();

      return reports;
    } catch (e) {
      return [];
    }
  }

  Future<ReportItemModel?> getAUserReport(String reportId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection("reportItems")
          .where("id", isEqualTo: reportId)
          .get();

      if (snapshot.docs.isEmpty) {
        // Handle the case where no document with the given ID is found
        return null;
      }

      final ReportItemModel report =
          ReportItemModel.fromSnapshot(snapshot.docs.first);

      return report;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteUserReport(String reportId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection("reportItems")
          .where("id", isEqualTo: reportId)
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }

      final document = snapshot.docs.first;

      await _firebaseFirestore
          .collection("reportItems")
          .doc(document.id)
          .delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateReport(
      String reportId,
      GeoPoint? coordinate,
      String? status,
      String? country,
      String? city,
      String? address,
      String? title,
      String? description) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection("reportItems")
          .where("id", isEqualTo: reportId)
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }

      final document = snapshot.docs.first;

      // Prepare the fields to update
      Map<String, dynamic> updateData = {};
      if (coordinate != null) updateData['coordinates'] = coordinate;
      if (city != null) updateData["city"] = city;
      if (address != null) updateData["address"] = address;
      if (country != null) updateData["country"] = country;
      if (status != null) updateData['status'] = status;
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;

      if (updateData.isNotEmpty) {
        await document.reference.update(updateData);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> markReportAsRecovered(String reportId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection("reportItems")
          .where("id", isEqualTo: reportId)
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }

      final document = snapshot.docs.first;

      // Prepare the fields to update
      Map<String, dynamic> updateData = {};
      updateData['recovered'] = true;

      if (updateData.isNotEmpty) {
        await document.reference.update(updateData);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAIStatus(String reportId) async {
    try {
      final snapshot = await _firebaseFirestore
          .collection("reportItems")
          .where("id", isEqualTo: reportId)
          .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }

      final document = snapshot.docs.first;

      // Prepare the fields to update
      Map<String, dynamic> updateData = {};
      updateData['hasAIStarted'] = true;

      if (updateData.isNotEmpty) {
        await document.reference.update(updateData);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
