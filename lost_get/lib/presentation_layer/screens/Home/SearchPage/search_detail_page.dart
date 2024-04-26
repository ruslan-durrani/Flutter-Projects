import 'package:flutter/material.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/Home/SearchPage/search_page.dart';
import 'package:lost_get/presentation_layer/screens/Home/home_screen.dart';

import '../controller/home_screen_reports_controller.dart';
import '../item_detail_screen.dart';
import '../widgets/reportedItemCard.dart';

class SearchDetailPage extends StatefulWidget {
  final String searchedText;
  final List<ReportItemModel> reportedItems;
  static const routeName = "/search_detail_screen";

  const SearchDetailPage({super.key, required this.searchedText, required this.reportedItems});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchDetailPage> {
  late final List<ReportItemModel> _searchedItems;
  late final String _searchText;

  @override
  void initState() {
    super.initState();
    _searchText = widget.searchedText;
    _searchedItems = widget.reportedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=>Navigator.popAndPushNamed(context, HomeScreen.routeName),
            child: Icon(Icons.arrow_back_rounded,color: Colors.black,)),
        title: Text(_searchText,style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),)
      ),
      body: ListView.builder(
        itemCount: _searchedItems.length,
        itemBuilder: (context, index) {
          final item = _searchedItems[index];

          return  Padding(
            padding: const EdgeInsets.all(18.0),
            child: InkWell(
                onTap: ()=>onItemTapped(item),
                child: Container(
                    width: double.maxFinite,
                    child: ReportedItemCard(item: item, onTap: () => onItemTapped(item)))),
          );
        },
      )
    );
  }
  onItemTapped(item) {
    Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
  }
}
