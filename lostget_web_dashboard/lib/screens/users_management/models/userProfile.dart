import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? fullName;
  final String? email;
  final bool? isAdmin;
  final String? phoneNumber;
  final DateTime? joinedDateTime;
  final String? biography;
  final List<dynamic>? preferenceList;
  final String? dateOfBirth;
  final String? imgUrl;
  final String? gender;
  final List<dynamic>? userChatsList;
  final String? uid;

  const UserProfile({
    required this.fullName,
    required this.uid,
    required this.email,
    required this.isAdmin,
    required this.joinedDateTime,
    required this.phoneNumber,
    required this.biography,
    required this.preferenceList,
    required this.imgUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.userChatsList,
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
      'uid': uid,
      'userChatsList': userChatsList,
    };
  }

  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserProfile(
      fullName: data['fullName'],
      biography: data['biography'],
      phoneNumber: data['phoneNumber'],
      preferenceList: data['preferenceList'] as List<dynamic>,
      isAdmin: data['isAdmin'],
      email: data['email'],
      imgUrl: data['imgUrl'],
      dateOfBirth: data['dateOfBirth'],
      gender: data['gender'],
      joinedDateTime: data['joinedDateTime'].toDate(),
      userChatsList: data['userChatsList'],
      uid: data['uid'],
    );
  }
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    // Ensure proper type casting for userChatsList
    final List<String> userChatsList =
    (map['userChatsList'] as List).map((item) => item.toString()).toList();

    return UserProfile(
        uid: map['uid'] ?? '',
        fullName: map['fullName'] ?? '',
        email: map['email'] ?? '',
        isAdmin: map['isAdmin'] ?? false,
        joinedDateTime: (map['joinedDateTime'] as Timestamp).toDate(),
        phoneNumber: map['phoneNumber'] ?? '',
        biography: map['biography'] ?? '',
        preferenceList: map['preferenceList'] as List<dynamic>,
        imgUrl: map['imgUrl'] ?? '',
        dateOfBirth: map['dateOfBirth'],
        gender: map['gender'] ?? '',
        userChatsList: map["userChatsList"] as List<dynamic>);
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserProfile {
//   final String? fullName;
//   final String? email;
//   final bool? isAdmin;
//   final DateTime? joinedDateTime;
//   final String? phoneNumber;
//   final String? biography;
//   final Map<String, dynamic>? preferenceList;
//   final String? dateOfBirth;
//   final String? imgUrl;
//   final String? gender;
//   final String? password;
//   const UserProfile({
//     required this.fullName,
//     required this.email,
//     required this.isAdmin,
//     required this.joinedDateTime,
//     required this.phoneNumber,
//     required this.biography,
//     required this.preferenceList,
//     required this.imgUrl,
//     required this.dateOfBirth,
//     required this.gender,
//     required this.password
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'isAdmin': isAdmin,
//       'fullName': fullName,
//       'email': email,
//       'joinedDateTime': joinedDateTime,
//       'gender': gender,
//       'phoneNumber': phoneNumber,
//       'biography': biography,
//       'preferenceList': preferenceList,
//       'imgUrl': imgUrl,
//       'dateOfBirth': dateOfBirth,
//       'password': password,
//     };
//   }
//
//   factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return UserProfile(
//         fullName: data['fullName'],
//         biography: data['biography'],
//         phoneNumber: data['phoneNumber'],
//         preferenceList: data['preferenceList'] as Map<String, dynamic>,
//         isAdmin: data['isAdmin'],
//         email: data['email'],
//         imgUrl: data['imgUrl'],
//         dateOfBirth: data['dateOfBirth'],
//         gender: data['gender'],
//         joinedDateTime: data['joinedDateTime'].toDate(),
//         password: data['password']
//     );
//   }
// }
