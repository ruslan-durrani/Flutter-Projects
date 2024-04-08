import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/createChip.dart';

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
        height: 160,
        width: MediaQuery.of(context).size.width * .95,
        decoration:  BoxDecoration(
          color: Colors.white,
            border: Border.all(
              width: 2,
              color: AppColors.primaryColor.withOpacity(.2),
            ),
            borderRadius: BorderRadius.circular(15),),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .45, // Specify the width
                    height: 160, // Match the card height or adjust as needed
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.item.imageUrls?.first ?? ''),
                        fit: BoxFit.cover, // Adjust to cover to fill the box, keeping aspect ratio
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      createLostFoundChip(widget.item, context),
                      createPublishChip(_formatDateTime(widget.item.publishDateTime), context),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.title ?? 'Unknown',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15,fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 2),
                    Text(
                      widget.item.city ?? 'Unknown location',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 2 ),
                    Text(
                      widget.item.description ?? 'No description provided.',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3, // Adjust the number of lines for description
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        ),

    );
  }
}
