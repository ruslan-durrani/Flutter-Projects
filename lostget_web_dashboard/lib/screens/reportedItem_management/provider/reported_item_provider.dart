import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_dashboard/screens/users_management/models/report_item.dart';

class ReportedItemsProvider with ChangeNotifier {
  List<ReportItemModel> _reportedItems = [];
  Set<String> _selectedItems = {};
  String _searchQuery = '';
  String _filterType = 'title'; // Default to 'title'

  List<ReportItemModel> get reportedItems => _reportedItems;
  Set<String> get selectedItems => _selectedItems;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterType(String filterType) {
    _filterType = filterType;
    notifyListeners();
  }

  Future<void> fetchReportedItems() async {
    QuerySnapshot snapshot;
    if (_searchQuery.isNotEmpty) {
      // Adjust fieldPath based on selected filter
      String fieldPath = _filterType == 'location' ? 'city' : _filterType;
      snapshot = await FirebaseFirestore.instance
          .collection('reportItems')
          .where(fieldPath, isGreaterThanOrEqualTo: _searchQuery)
          .where(fieldPath, isLessThanOrEqualTo: _searchQuery + '\uf8ff')
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance.collection('reportItems').get();
    }
    _reportedItems = snapshot.docs.map((doc) => ReportItemModel.fromSnapshot(doc)).toList();
    notifyListeners();
  }

  void toggleSelection(String itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId);
    } else {
      _selectedItems.add(itemId);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }
}
