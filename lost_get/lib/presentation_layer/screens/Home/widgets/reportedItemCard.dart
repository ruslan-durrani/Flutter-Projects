import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/common/constants/colors.dart';

import '../../../../models/report_item.dart'; // Add intl package to your pubspec.yaml

class ReportedItemCard extends StatefulWidget {
  final ReportItemModel item;
  final VoidCallback onTap;

  const ReportedItemCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  _ReportedItemCardState createState() => _ReportedItemCardState();
}

class _ReportedItemCardState extends State<ReportedItemCard> {
  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown time';
    final Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays >= 1) {
      return '${difference.inDays} Days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} Hours ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          // clipBehavior: Clip.antiAlias,
          // elevation: 0.0,
          decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: AppColors.primaryColor.withOpacity(.2),
              ),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    height: 200,
                    decoration: BoxDecoration(
                      // color: Colors.grey,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      image: DecorationImage(
                        // image: AssetImage(widget.item.imageUrls?.first ?? ''),
                        image: NetworkImage(widget.item.imageUrls?.first ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(widget.item.status ?? 'Unknown',
                              style: const TextStyle(color: Colors.white)),
                          backgroundColor: widget.item.status!.contains("Found")
                              ? Colors.green
                              : Colors.red,
                        ),
                        Chip(
                          label: Text(
                              _formatDateTime(widget.item.publishDateTime),
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.item.title ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const TextSpan(
                            text: '\n',
                          ),
                          TextSpan(
                            text: widget.item.city ?? 'Unknown location',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      softWrap: true,
                      widget.item.description ?? 'No description provided.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
