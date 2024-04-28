import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:lost_get/utils/api_services.dart';
import 'package:lost_get/utils/location_utils.dart';

import '../../../../models/report_item.dart';
import '../../../widgets/toast.dart';

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

      items = unflaggedItems;
      listOfNearbyItems = items;
      listOfRecommendedItems = items;
      listOfCategories = items;
    } catch (error) {
      print("Error fetching items: $error");
    }
  }
  Future<void> fetchNearbyItems() async {
    try {
      LocationUtils locationUtils = LocationUtils(10);
      locationUtils.getCurrentLocationAndUpdate();
      listOfNearbyItems = locationUtils.itemsNearby;
      print(listOfNearbyItems);
      // listOfNearbyItems = locationUtils.itemsNearby;
      // fetchAllItems();
      // listOfNearbyItems = listOfRecommendedItems
    }
    catch (e) {
      print("Error fetching search suggestions: $e");
    }
  }

  Future<List<ReportItemModel>> fetchSearchSuggestions(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reportItems')
      // You might want to limit the number of items fetched if your collection is large
          .limit(50)
          .get();

      // Filter the results in Dart
      return querySnapshot.docs
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .where((item) => item.description!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      print("Error fetching search suggestions: $e");
      return [];
    }
  }
  Future<List<ReportItemModel>> fetchReportedItemBasedOnCity(String address,String city,String country) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reportItems')
      // You might want to limit the number of items fetched if your collection is large
          .limit(50)
          .get();

      // Filter the results in Dart
      return querySnapshot.docs
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .where((item) => (((item.city!.toLowerCase().contains(city.toLowerCase()))&&(item.country!.toLowerCase().contains(city.toLowerCase())))||(item.address!.toLowerCase().contains(address.toLowerCase()))))
          .toList();
    } catch (e) {
      print("Error fetching search suggestions: $e");
      return [];
    }
  }
  Future<List<ReportItemModel>> fetchReportedItemBasedOnSearchFilter(String address,String city,String country,String title) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('reportItems')
          .limit(50)
          .get();

      // Filter the results in Dart
      return querySnapshot.docs
          .map((doc) => ReportItemModel.fromSnapshot(doc))
          .where(
              (item) => (
                  (
                item.city!.toLowerCase().contains(city.toLowerCase())
                ||(item.country!.toLowerCase().contains(city.toLowerCase()))
                ||item.address!.toLowerCase().contains(address.toLowerCase())
                )
                &&
                  (
                      item.title!.toLowerCase().contains(title.toLowerCase())
                      ||item.description!.toLowerCase().contains(title.toLowerCase())
                  )
              )
          )
          .toList();
    } catch (e) {
      print("Error fetching search suggestions: $e");
      return [];
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
