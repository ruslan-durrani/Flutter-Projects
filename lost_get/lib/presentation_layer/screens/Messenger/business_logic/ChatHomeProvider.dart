import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  List<Map<String, dynamic>> _chatUsers = [];

  List<Map<String, dynamic>> get chatUsers => _chatUsers;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
    fetchChatUsers();
  }

  Future<void> fetchChatUsers() async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    var query = _firestore.collection('users').where('uid', isNotEqualTo: currentUserUid);

    if (_searchQuery.isNotEmpty) {
      query = query.where('fullName', isGreaterThanOrEqualTo: _searchQuery)
          .where('fullName', isLessThanOrEqualTo: _searchQuery + '\uf8ff');
    }

    final snapshot = await query.get();
    _chatUsers = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    notifyListeners();
  }
}
