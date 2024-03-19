import 'package:cloud_firestore/cloud_firestore.dart';

class ReportItemModel {
  String? id;
  final String? title;
  final String? description;
  final String? status;
  List<String>? imageUrls;
  final String? userId;
  final String? category;
  final String? subCategory;
  final DateTime? publishDateTime;
  final String? address;
  final String? city;
  final String? country;
  final GeoPoint? coordinates;
  final bool? flagged;
  final bool? published;

  ReportItemModel(

      {
        this.id,
        required this.title,
      required this.description,
      required this.status,
      this.imageUrls,
      required this.userId,
      required this.category,
      required this.subCategory,
      required this.publishDateTime,
      required this.address,
      required this.city,
      required this.country,
      required this.coordinates,
      required this.flagged,
      required this.published});

  Map<String, dynamic> toMap() {
    return {
      "id":id,
      'title': title,
      'description': description,
      'status': status,
      'imageUrls': imageUrls,
      'userId': userId,
      'category': category,
      'subCategory': subCategory,
      'address': address,
      'city': city,
      'country': country,
      'coordinates': coordinates,
      'flagged': flagged,
      'publishDateTime': publishDateTime,
      'published': published
    };
  }

  factory ReportItemModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    List<String> imageUrls = [];
    if (data['imageUrls'] != null) {
      if (data['imageUrls'] is List<dynamic>) {
        // Convert dynamic list to List<String>
        imageUrls = List<String>.from(data['imageUrls'] as List<dynamic>);
      } else {
        // If it's a single string, convert it to a list
        imageUrls = [data['imageUrls'] as String];
      }
    }

    return ReportItemModel(
      id:data['id'],
      title: data['title'],
      description: data['description'],
      status: data['status'],
      imageUrls: imageUrls,
      userId: data['userId'],
      category: data['category'],
      subCategory: data['subCategory'],
      address: data['address'],
      city: data["city"],
      country: data["country"],
      coordinates: data["coordinates"],
      flagged: data["flagged"],
      published: data['published'],
      publishDateTime: data['publishDateTime'].toDate(),
    );
  }


}
