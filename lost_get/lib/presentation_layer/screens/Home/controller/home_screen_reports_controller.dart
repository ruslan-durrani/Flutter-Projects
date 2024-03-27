import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lost_get/utils/api_services.dart';

import '../../../../models/report_item.dart';

class HomeScreenController {
  List<ReportItemModel> listOfRecommendedItems = [];
  List<ReportItemModel> listOfNearbyItems = [];
  List<ReportItemModel> listOfCategories = [];
  List<ReportItemModel> listOfRecentUploads = [];
  List<ReportItemModel> listOfSpecificCategory = [];

  Future<void> fetchAllItems() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('reportItems').get();
      List<ReportItemModel> items = querySnapshot.docs
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .toList();

      // Remove flagged items
      List<ReportItemModel> unflaggedItems = items
          .where(
              (item) => !item.flagged! && !item.recovered! && item.published!)
          .toList();

      listOfRecommendedItems =
          await recommendReports(FirebaseAuth.instance.currentUser!.uid);
      items = unflaggedItems;
      listOfNearbyItems = items;
      listOfCategories = items;
    } catch (error) {
      print("Error fetching items: $error");
    }

  }

  Future<void> myRecentUploads() async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('reportItems').get();
      List<ReportItemModel> items = querySnapshot.docs.where((element) => element["userId"]==FirebaseAuth.instance.currentUser!.uid)
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .toList();

      // Remove flagged items
      List<ReportItemModel> unflaggedItems = items
          .where(
              (item) => !item.flagged! && !item.recovered! && item.published!)
          .toList();

      items = unflaggedItems;
      listOfRecentUploads = items;
    } catch (error) {
      print("Error fetching items: $error");
    }
  }

  Future<List<ReportItemModel>> specificCategory(String category) async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('reportItems').get();
      List<ReportItemModel> items = querySnapshot.docs
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .toList();

      // Remove flagged items
      List<ReportItemModel> unflaggedItems = items
          .where(
              (item) => !item.flagged! && !item.recovered! && item.published!)
          .toList();

      // Assuming you're looking for items in the "Electronics" category
      String specificCategory = category;
      List<ReportItemModel> itemsInSpecificCategory = unflaggedItems
          .where((item) => item.category == specificCategory)
          .toList();

      // If you need to separate items by categories dynamically, consider using a Map
      Map<String, List<ReportItemModel>> itemsByCategory = {};
      for (var item in unflaggedItems) {
        if (!itemsByCategory.containsKey(item.category)) {
          itemsByCategory[item.category!] = [];
        }
        itemsByCategory[item.category]!.add(item);
      }

      return itemsInSpecificCategory;
    } catch (error) {
      print("Error fetching items: $error");
      return [];
    }
  }
}
