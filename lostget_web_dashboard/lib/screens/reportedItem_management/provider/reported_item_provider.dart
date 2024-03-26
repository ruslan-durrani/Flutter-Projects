import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_admin_dashboard/screens/users_management/models/report_item.dart';

class ReportedItemsProvider with ChangeNotifier {
  List<ReportItemModel> _allReportedItems = []; // Holds all items fetched from Firestore
  List<ReportItemModel> _reportedItems = []; // Holds currently displayed items after filtering
  Set<String> _selectedItems = {};
  String _searchQuery = '';
  String _filterType = 'title'; // Default to 'title'

  // Getter to provide the filtered list of reported items
  List<ReportItemModel> get reportedItems => _reportedItems;
  Set<String> get selectedItems => _selectedItems;

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterReportedItemsLocally(); // Apply filters locally upon changing the search query
  }

  void setFilterType(String filterType) {
    _filterType = filterType;
    _filterReportedItemsLocally(); // Apply filters locally upon changing the filter type
  }

  // Fetch all reported items initially and store them
  Future<void> fetchReportedItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('reportItems').get();
    _allReportedItems = snapshot.docs.map((doc) => ReportItemModel.fromSnapshot(doc)).toList();
    _filterReportedItemsLocally(); // Apply current filters to the fetched data
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

  // Method to filter reported items locally based on the current search query and filter type
  void _filterReportedItemsLocally() {
    if (_searchQuery.isNotEmpty) {
      _reportedItems = _allReportedItems.where((item) {
        String itemValue = ''; // Initialize with default empty string
        switch (_filterType) {
          case 'title':
            itemValue = item.title ?? '';
            break;
          case 'description':
            itemValue = item.description ?? '';
            break;
        // Add more cases here for other filter types if necessary
        }
        return itemValue.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    } else {
      _reportedItems = List.from(_allReportedItems); // No filtering, use all items
    }
    notifyListeners(); // Notify listeners to update the UI with filtered items
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:responsive_admin_dashboard/screens/users_management/models/report_item.dart';
//
// class ReportedItemsProvider with ChangeNotifier {
//   List<ReportItemModel> _reportedItems = [];
//   Set<String> _selectedItems = {};
//   String _searchQuery = '';
//   String _filterType = 'title'; // Default to 'title'
//
//   List<ReportItemModel> get reportedItems => _reportedItems;
//   Set<String> get selectedItems => _selectedItems;
//
//   void setSearchQuery(String query) {
//     _searchQuery = query;
//     notifyListeners();
//   }
//
//   void setFilterType(String filterType) {
//     _filterType = filterType;
//     notifyListeners();
//   }
//
//   Future<void> fetchReportedItems() async {
//     QuerySnapshot snapshot;
//     if (_searchQuery.isNotEmpty) {
//       // Adjust fieldPath based on selected filter
//       String fieldPath = _filterType == 'location' ? 'city' : _filterType;
//       snapshot = await FirebaseFirestore.instance
//           .collection('reportItems')
//           .where(fieldPath, isGreaterThanOrEqualTo: _searchQuery)
//           .where(fieldPath, isLessThanOrEqualTo: _searchQuery + '\uf8ff')
//           .get();
//     } else {
//       snapshot = await FirebaseFirestore.instance.collection('reportItems').get();
//     }
//     _reportedItems = snapshot.docs.map((doc) => ReportItemModel.fromSnapshot(doc)).toList();
//     notifyListeners();
//   }
//
//   void toggleSelection(String itemId) {
//     if (_selectedItems.contains(itemId)) {
//       _selectedItems.remove(itemId);
//     } else {
//       _selectedItems.add(itemId);
//     }
//     notifyListeners();
//   }
//
//   void clearSelection() {
//     _selectedItems.clear();
//     notifyListeners();
//   }
// }
