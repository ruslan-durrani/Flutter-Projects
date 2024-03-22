import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_dashboard/global/services/firebase_service.dart';
import 'package:responsive_admin_dashboard/global/widgets/toastFlutter.dart';

import '../../screens/users_management/models/userProfile.dart';

class FireStoreService {
  final FirebaseFirestore _firestore;
  FireStoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  myProfileInformationUpdate(
      {required String email,
      required String bio,
      required gender,
      required String dateOfBirth,
      required String name}) async {
    await _firestore
        .collection('users')
        .doc(FirebaseService().getMyUID())
        .update(
      {
        'imgUrl': "",
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'fullName': name,
        'biography': bio,
      },
    );
  }
 updateUserProfile(
      {required String email,
      required String bio,
      required gender,
      required String dateOfBirth,
      required String name}) async {
   QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
   // Check if a document with the provided email exists
   if (querySnapshot.docs.isNotEmpty) {
     DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
     await documentSnapshot.reference.update({
       'dateOfBirth': dateOfBirth,
       'gender': gender,
       'fullName': name,
       'biography': bio,
     });
     toasterFlutter('User Profile Successfully Updated');
     return true;
   } else {
     toasterFlutter('Error finding user with email $email.');
     return false;
   }
  }


  Future<void> createUserProfile(String uid,Map<String, dynamic> admin) async {
    final userProfileRef = _firestore.collection('users');
    await userProfileRef.doc(uid).set(admin);
  }


  Future<bool> getIsAdmin() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firestore
        .collection('users')
        .doc(FirebaseService().getMyUID())
        .get();

    if (userSnapshot.exists) {
      final isAdmin = userSnapshot.data()?['isAdmin'] ?? false;
      print(isAdmin);
      return isAdmin;
    } else {
      print("Not Admin");
      return true;
    }
  }

  Future<List<Map<String, dynamic>>> getUsersRegisteredLastTwoWeeks() async {
    final DateTime now = DateTime.now();
    final DateTime twoWeeksAgo = now.subtract(Duration(days: 14));
    List<Map<String, dynamic>> map = [];
    for (int i = 0; i < now.difference(twoWeeksAgo).inDays; i++) {
      map.add({
        "user_count": 0,
        "date_millisecond": now.subtract(Duration(days: 14 - i)).millisecondsSinceEpoch
      });
    }
    List<int> registrationCounts = List.filled(14, 0);
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      final userDoc = usersSnapshot.docs;
      for (int i = 0; i<userDoc.length; i++) {
        Timestamp joinTimestamp = userDoc[i]['joinedDateTime'];
        DateTime joinDate = joinTimestamp.toDate();
        print("Processing user: $joinDate"); // Debug print
        int daysAgo = now.difference(joinDate).inDays;
        if (joinDate.isAfter(twoWeeksAgo) && joinDate.isBefore(now)) {
          registrationCounts[13 - daysAgo]++;
          map[13-daysAgo].update("user_count", (value) => ++value);
          print("Updated count for day ${13-daysAgo} to ${map[13-daysAgo]["user_count"]}"); // Debug print
        }
      }


      print(registrationCounts);
      return map;
      // return registrationCounts;
    } catch (error) {
      throw Exception('Error fetching user data: $error');
    }
  }
}
