import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:lost_get/models/matched_reports.dart';
import 'package:lost_get/models/report_item.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:lost_get/data_store_layer/repository/users_base_repository.dart';
import 'package:rxdart/rxdart.dart';

class AIReportItemRepository extends BaseUsersRepository {
  final FirebaseFirestore _firebaseFirestore;

  AIReportItemRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

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

  Future<List<ReportItemModel>> getUserMatchedReports() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return []; // Handle the case where there is no user logged in.
    }

    var userReports = await fetchReports('userId', uid, 'isUserMarked');
    print("user Reports are ${userReports.length}");

    // print("All reports are ${allReports.length}");
    var ids = userReports.map((report) => report.matchedReportId).toSet();
    print("ids are ${ids}");

    // Fetch corresponding reportItems
    return await fetchReportItems(ids.toList(), userReports);
  }

  Future<List<AIMatchedReportModel>> fetchReports(
      String field, String uid, String markField) async {
    var snapshot = await _firebaseFirestore
        .collection('matchedReports')
        .where(field, isEqualTo: uid)
        .get();

    return snapshot.docs.isEmpty
        ? []
        : snapshot.docs
            .map((doc) => AIMatchedReportModel.fromSnapshot(doc))
            .where((report) => report.getField(markField) != 'not-accepted')
            .toList();
  }

  Future<List<ReportItemModel>> fetchReportItems(
      List<String?> ids, List<AIMatchedReportModel> matchReportData) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    var snapshot = await _firebaseFirestore
        .collection('reportItems')
        .where('id', whereIn: ids)
        .get();

    var listOfReports = snapshot.docs
        .map((doc) => ReportItemModel.fromSnapshot(doc))
        .where((item) => item.userId != uid)
        .toList();
    return listOfReports.map((item) {
      var matchedReport = matchReportData
          .firstWhere((report) => report.matchedReportId == item.id);
      return ReportItemModel(
          id: item.id,
          address: item.address,
          category: item.category,
          city: item.city,
          coordinates: item.coordinates,
          country: item.country,
          description: item.description,
          flagged: item.flagged,
          hasAIStarted: item.hasAIStarted,
          hasReportToPoliceStationStarted: item.hasReportToPoliceStationStarted,
          publishDateTime: item.publishDateTime,
          published: item.published,
          recovered: item.recovered,
          reportStatusByPolice: item.reportStatusByPolice,
          status: item.status,
          subCategory: item.subCategory,
          title: item.title,
          userId: item.userId,
          imageUrls: item.imageUrls,
          matchPercentage: matchedReport.matchPercentage);
    }).toList();
  }

  Future<bool> acceptAIMatchedReport(String reportId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return false; // Handle the case where there is no user logged in.
    }

    var snapshot = await _firebaseFirestore
        .collection('matchedReports')
        .where("matchedReportId", isEqualTo: reportId)
        .where("userId", isEqualTo: uid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      print("inside one part");
      var docId = snapshot.docs.first.id;
      var userReportId = snapshot.docs.first.data()['userReportId'];
      // Do something with userReportId, like printing it
      print(userReportId);
      await FirebaseFirestore.instance
          .collection('matchedReports')
          .doc(docId)
          .update({'isUserMarked': 'accepted'});

      var updateAllSnapshot = await _firebaseFirestore
          .collection('matchedReports')
          .where("userReportId", isEqualTo: userReportId)
          .where("userId", isEqualTo: uid)
          .where("isUserMarked", isNotEqualTo: 'accepted')
          .get();

      // Check if the snapshot has data and is not empty
      if (updateAllSnapshot.docs.isNotEmpty) {
        // Iterate through all the documents in the snapshot
        for (var doc in updateAllSnapshot.docs) {
          // Get the document ID
          String documentId = doc.id;
          // Update the 'isUserMarked' field for each document
          await _firebaseFirestore
              .collection('matchedReports')
              .doc(documentId)
              .update({'isUserMarked': 'not-accepted'});
        }
      }

      return true;
    }

    return false;
  }

  Future<bool> declineUserReport(String reportId) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return false; // Handle the case where there is no user logged in.
      }

      var snapshot = await _firebaseFirestore
          .collection('matchedReports')
          .where("matchedReportId", isEqualTo: reportId)
          .where("userId", isEqualTo: uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        print("inside one part");
        var docId = snapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('matchedReports')
            .doc(docId)
            .update({'isUserMarked': 'not-accepted'});

        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<bool> checkIsMatchReportAccepted(String reportId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print("report id are ${uid}");
    var snapshot = await _firebaseFirestore
        .collection('matchedReports')
        .where("matchedReportId", isEqualTo: reportId)
        .where("userId", isEqualTo: uid)
        .where("isUserMarked", isEqualTo: "accepted")
        .get();

    return snapshot.docs.isEmpty ? false : true;
  }

  Future<bool> isUserReportAwaiting(String reportId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    print("report id are ${uid}");
    var snapshot = await _firebaseFirestore
        .collection('matchedReports')
        .where("userReportId", isEqualTo: reportId)
        .where("userId", isEqualTo: uid)
        .where("isUserMarked", isEqualTo: "awaiting")
        .get();

    return snapshot.docs.isEmpty ? false : true;
  }
}
