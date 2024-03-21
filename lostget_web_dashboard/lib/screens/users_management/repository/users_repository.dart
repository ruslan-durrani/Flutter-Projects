import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:responsive_admin_dashboard/screens/users_management/repository/users_base_repository.dart';
import '../../../global/services/firebase_service.dart';
import '../models/userProfile.dart';

class UserRepository extends BaseUsersRepository{
  final FirebaseFirestore _firebaseFirestore;
  UserRepository({FirebaseFirestore? firebaseFirestore}):_firebaseFirestore=firebaseFirestore??FirebaseFirestore.instance;
  @override
  Stream<List<UserProfile>> getAllUserData() {
    return _firebaseFirestore
        .collection("users")
        .snapshots()
        .map((snap) {
          return snap.docs.map((e) => UserProfile.fromSnapshot(e)).toList();
    });
  }
}