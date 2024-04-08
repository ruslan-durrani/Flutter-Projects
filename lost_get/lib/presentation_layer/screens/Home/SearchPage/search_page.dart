import 'package:flutter/material.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';

import '../controller/home_screen_reports_controller.dart';
import '../item_detail_screen.dart';
import '../widgets/reportedItemCard.dart';

class SearchPage extends StatefulWidget {
  static const routeName = "/search_screen";

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final HomeScreenController _homeScreenController = HomeScreenController();
  List<ReportItemModel> _searchResults = [];
  bool _isSearching = false;

  void _onSearchChanged(String query) async {
    if (query.isNotEmpty) {
      setState(() => _isSearching = true);
      List<ReportItemModel> results = await _homeScreenController.fetchSearchSuggestions(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 45,
          decoration: BoxDecoration(color: AppColors.lightPurpleColor, borderRadius: BorderRadius.circular(100)),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter keyword, category, or location",
              hintStyle: TextStyle(fontSize: 13),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(105.0)), borderSide: BorderSide.none),
            ),
          ),
        ),
      ),
      body: _isSearching
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final item = _searchResults[index];
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ReportedItemCard(item: item, onTap: () => onItemTapped(item)));
        },
      ),
    );
  }
  onItemTapped(item) {
    Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
  }
}
