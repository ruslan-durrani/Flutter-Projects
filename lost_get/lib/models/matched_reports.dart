import 'package:cloud_firestore/cloud_firestore.dart';

class AIMatchedReportModel {
  final String? isMatchedUserMarked;
  final String? isUserMarked;
  final String? matchedReportId;
  final String? matchedUserId;
  final int? matchPercentage;
  final DateTime? timestamp;
  final String? userId;
  final String? userReportId;

  AIMatchedReportModel(
      {required this.isMatchedUserMarked,
      required this.isUserMarked,
      required this.matchedReportId,
      required this.matchedUserId,
      required this.matchPercentage,
      required this.timestamp,
      required this.userId,
      required this.userReportId});

  Map<String, dynamic> toMap() {
    return {
      'isMatchedUserMarked': isMatchedUserMarked,
      'isUserMarked': isUserMarked,
      'matchedReportId': matchedReportId,
      'matchedUserId': matchedUserId,
      'matchPercentage': matchPercentage,
      'joinedDateTime': timestamp,
      'userId': userId,
      'userReportId': userReportId,
    };
  }

  factory AIMatchedReportModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return AIMatchedReportModel(
      isMatchedUserMarked: data['isMatchedUserMarked'],
      isUserMarked: data['isUserMarked'],
      matchedReportId: data['matchedReportId'],
      matchedUserId: data['matchedUserId'],
      matchPercentage: data['matchPercentage'],
      userId: data['userId'],
      userReportId: data['userReportId'],
      timestamp: data['timestamp'].toDate(),
    );
  }

  dynamic getField(String fieldName) {
    switch (fieldName) {
      case 'isMatchedUserMarked':
        return isMatchedUserMarked;
      case 'isUserMarked':
        return isUserMarked;
      case 'matchedReportId':
        return matchedReportId;
      case 'matchedUserId':
        return matchedUserId;
      case 'matchPercentage':
        return matchPercentage;
      case 'userId':
        return userId;
      case 'userReportId':
        return userReportId;
      case 'timestamp':
        return timestamp;
      default:
        return null;
    }
  }
}
