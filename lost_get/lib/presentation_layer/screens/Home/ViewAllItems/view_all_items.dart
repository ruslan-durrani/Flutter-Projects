import 'package:flutter/material.dart';

import '../../../../models/report_item.dart';
import '../controller/home_screen_reports_controller.dart';
import '../item_detail_screen.dart';
import '../widgets/reportedItemCard.dart';

class ViewAllItems extends StatefulWidget {
  static const routeName = "/view_all_items";
  final String titleName;
  final List<ReportItemModel> reportedItemList;
  const ViewAllItems({super.key, required this.titleName, required this.reportedItemList});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  HomeScreenController controller = HomeScreenController();

  onItemTapped(item) {
    Navigator.pushNamed(context, ItemDetailScreen.routeName, arguments: item);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.titleName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.reportedItemList.length,
        itemBuilder: (context, index) {
          final ReportItemModel item = widget.reportedItemList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReportedItemCard(
                item: item, onTap: () => onItemTapped(item)),
          );
          },
      ),
    );
  }
}
