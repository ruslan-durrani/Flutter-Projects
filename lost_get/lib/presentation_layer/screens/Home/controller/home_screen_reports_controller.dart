import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/report_item.dart';
import '../widgets/reportedItemCard.dart';


  // List<ReportItemModel> listOfRecommendedItems=[];
  // List<ReportItemModel> listOfNearbyItems=[];
  // List<ReportItemModel> listOfCategories=[];
  // List<ReportItemModel> listOfRecentUploads=[];
  //
  // ReportItemModel dummyItem = ReportItemModel(
  // title: "Macbook M1 Lost",
  // description: "Bag Lost near Library Comsats University Islamabad",
  // status: "Lost",
  // imageUrls: [
  // "assets/icons/watch_item_dummy.jpg" // Placeholder image URL
  // ],
  // userId: "user123",
  // category: "Electronics",
  // subCategory: "Laptops",
  // publishDateTime: DateTime.now().subtract(Duration(days: 7)),
  // address: "Library Comsats University",
  // city: "Islamabad",
  // country: "Pakistan",
  // coordinates: GeoPoint(33.6844, 73.0479), // Dummy coordinates for Islamabad
  // flagged: false,
  // published: true,
  // );
 
class HomeScreenController {
  List<ReportItemModel> listOfRecommendedItems = [];
  List<ReportItemModel> listOfNearbyItems = [];
  List<ReportItemModel> listOfCategories = [];
  List<ReportItemModel> listOfRecentUploads = [];
  List<ReportItemModel> listOfSpecificCategory = [];

  Future<void> fetchAllItems() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('reportItems').get();
      List<ReportItemModel> items = querySnapshot.docs.map((doc) => ReportItemModel.fromSnapshot(doc)).toList();

      // Remove flagged items
      List<ReportItemModel> unflaggedItems = items.where((item) => !item.flagged!).toList();
      items = unflaggedItems;
      listOfRecommendedItems = items;
      listOfNearbyItems = items;
      listOfCategories = items;
      listOfRecentUploads = items;
    } catch (error) {
      print("Error fetching items: $error");
    }
  }

  Future<List<ReportItemModel>> specificCategory(String category ) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('reportItems').get();
      List<ReportItemModel> items = querySnapshot.docs.map((doc) => ReportItemModel.fromSnapshot(doc)).toList();

      // Remove flagged items
      List<ReportItemModel> unflaggedItems = items.where((item) => !item.flagged!).toList();

      // Assuming you're looking for items in the "Electronics" category
      String specificCategory = category;
      List<ReportItemModel> itemsInSpecificCategory = unflaggedItems.where((item) => item.category == specificCategory).toList();

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
