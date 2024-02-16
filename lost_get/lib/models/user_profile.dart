import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? fullName;
  final String? email;
  final bool? isAdmin;
  final String? phoneNumber;
  final DateTime? joinedDateTime;
  final String? biography;
  final Map<String, dynamic>? preferenceList;
  final String? dateOfBirth;
  final String? imgUrl;
  final String? gender;
  
  const UserProfile({
    required this.fullName,
    required this.email,
    required this.isAdmin,
    required this.joinedDateTime,
    required this.phoneNumber,
    required this.biography,
    required this.preferenceList,
    required this.imgUrl,
    required this.dateOfBirth,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'isAdmin': isAdmin,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'biography': biography,
      'preferenceList': preferenceList,
      'imgUrl': imgUrl,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'joinedDateTime': joinedDateTime,
      
    };
  }

  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserProfile(
        fullName: data['fullName'],
        biography: data['biography'],
        phoneNumber: data['phoneNumber'],
        preferenceList: data['preferenceList'] as Map<String, dynamic>,
        isAdmin: data['isAdmin'],
        email: data['email'],
        imgUrl: data['imgUrl'],
        dateOfBirth: data['dateOfBirth'],
        gender: data['gender'],
        joinedDateTime: data['joinedDateTime'].toDate(),
       );
  }
}
