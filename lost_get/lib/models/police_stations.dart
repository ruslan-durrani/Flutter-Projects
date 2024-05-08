
import 'package:cloud_firestore/cloud_firestore.dart';

class PoliceStation {
  final String docId;
  final String stationName;
  final String address;
  final String city;
  final GeoPoint coordinates;
  final bool isApproved;

  PoliceStation({
    required this.docId,
    required this.stationName,
    required this.address,
    required this.city,
    required this.coordinates,
    required this.isApproved,
  });

  factory PoliceStation.fromFirestore(Map<String, dynamic> firestore, String docId) {
    return PoliceStation(
      docId: docId,
      stationName: firestore['stationName'] ?? '',
      address: firestore['address'] ?? '',
      city: firestore['city'] ?? '',
      coordinates: firestore['coordinates'],
      isApproved: firestore['isApproved'] ?? false,
    );
  }
}
