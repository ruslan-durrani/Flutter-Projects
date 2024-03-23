import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ReportItemModel {
  final String? id;
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
  final bool? recovered;

  ReportItemModel(
      {required this.id,
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
      required this.recovered,
      required this.published});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
      'published': published,
      'recovered': recovered
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
      id: data['id'],
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
      recovered: data['recovered'],
    );
  }

  factory ReportItemModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['imageUrls'] != null) {
      if (json['imageUrls'] is List<dynamic>) {
        // Convert dynamic list to List<String>
        imageUrls = List<String>.from(json['imageUrls'] as List<dynamic>);
      } else {
        // If it's a single string, convert it to a list
        imageUrls = [json['imageUrls'] as String];
      }
    }

    DateTime? publishDateTime;
    if (json['publishDateTime'] != null) {
      publishDateTime = DateTime.tryParse(json['publishDateTime']);
    }

    return ReportItemModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        category: json['category'],
        subCategory: json['subCategory'],
        address: json["address"],
        city: json["city"],
        coordinates: GeoPoint(
          json["coordinates"]['latitude'].toDouble(),
          json["coordinates"]['longitude'].toDouble(),
        ),
        country: json["country"],
        flagged: json["flagged"],
        publishDateTime: publishDateTime,
        published: json["published"],
        recovered: json["recovered"],
        status: json["status"],
        userId: json["userId"],
        imageUrls: imageUrls);
  }

  // factory GeoPoint.fromJson(Map<String, dynamic> json) {
  //   return GeoPoint(
  //     json['latitude'] as double,
  //     json['longitude'] as double,
  //   );
  // }
}
