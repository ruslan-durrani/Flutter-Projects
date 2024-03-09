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

  Future<void> fetchAllItems() async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('reportItems').get();
      List<ReportItemModel> items = querySnapshot.docs.map((doc) => ReportItemModel.fromSnapshot(doc)).toList();

      // Assuming all items are relevant for each category for simplicity
      listOfRecommendedItems = items;
      listOfNearbyItems = items;
      listOfCategories = items;
      listOfRecentUploads = items;
    } catch (error) {
      print("Error fetching items: $error");
    }
  }
}
