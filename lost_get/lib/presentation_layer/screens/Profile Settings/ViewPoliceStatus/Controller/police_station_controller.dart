import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_get/models/report_item.dart';

class PoliceStationStatusController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<ReportItemModel>> getAllReports() async {
    User? user = _auth.currentUser;
    List<ReportItemModel> reportItems = [];

    if (user != null) {
      String uid = user.uid;

      var reportedDocuments = await _firestore
          .collection('reportedToNeabyStations')
          .where('reportedBy', isEqualTo: uid)
          .get();

      // Collect all report_ids
      List<dynamic> reportIds = reportedDocuments.docs
          .map((doc) => doc.data()['reportId'])
          .whereType<String>() // Filter out nulls and ensure they are Strings
          .toList();

      if (reportIds.isNotEmpty) {
        QuerySnapshot<Map<String, dynamic>> reportItemsQuery;

        reportItemsQuery = await _firestore
            .collection('reportItems')
            .where('id', whereIn: reportIds)
            .get();

        reportItems = reportItemsQuery.docs
            .map((doc) => ReportItemModel.fromSnapshot(doc))
            .toList();
      }
    }
    return reportItems;
  }
}
