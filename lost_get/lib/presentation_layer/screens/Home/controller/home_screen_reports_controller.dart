import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/report_item.dart';
import '../widgets/reportedItemCard.dart';

class HomeScreenController{
  List<ReportItemModel> listOfRecommendedItems=[];
  List<ReportItemModel> listOfNearbyItems=[];
  List<ReportItemModel> listOfCategories=[];
  List<ReportItemModel> listOfRecentUploads=[];

  ReportItemModel dummyItem = ReportItemModel(
  title: "Macbook M1 Lost",
  description: "Bag Lost near Library Comsats University Islamabad",
  status: "Lost",
  imageUrls: [
  "assets/icons/watch_item_dummy.jpg" // Placeholder image URL
  ],
  userId: "user123",
  category: "Electronics",
  subCategory: "Laptops",
  publishDateTime: DateTime.now().subtract(Duration(days: 7)),
  address: "Library Comsats University",
  city: "Islamabad",
  country: "Pakistan",
  coordinates: GeoPoint(33.6844, 73.0479), // Dummy coordinates for Islamabad
  flagged: false,
  published: true,
  );

  fillUpDummy(){
    listOfRecommendedItems.addAll([dummyItem,dummyItem,dummyItem,dummyItem,dummyItem]);
    listOfNearbyItems.addAll([dummyItem,dummyItem,dummyItem,dummyItem,dummyItem]);
    listOfCategories.addAll([dummyItem,dummyItem,dummyItem,dummyItem,dummyItem]);
    listOfRecentUploads.addAll([dummyItem,dummyItem,dummyItem,dummyItem,dummyItem]);
  }

  HomeScreenController(){
    fillUpDummy();
  }
  List<ReportItemModel> getRecommendationsItem(){

    return listOfRecommendedItems;
  }
  List<ReportItemModel> getNearbyItem(){
    return listOfNearbyItems;
  }
  List<ReportItemModel> getCategoriesItem(){
    return listOfCategories;
  }
  List<ReportItemModel> getRecentUploadsItem(){
    return listOfRecentUploads;
  }
}