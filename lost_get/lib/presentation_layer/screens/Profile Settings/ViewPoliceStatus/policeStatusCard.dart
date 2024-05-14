import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lost_get/business_logic_layer/ViewPoliceStatus/bloc/view_police_station_status_bloc.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/createChip.dart';

import '../../../../models/report_item.dart'; // Add intl package to your pubspec.yaml

class PoliceStatusCard extends StatefulWidget {
  final ReportItemModel item;

  final ViewPoliceStationStatusBloc policeStatusBloc;

  const PoliceStatusCard({
    super.key,
    required this.item,
    required this.policeStatusBloc,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PoliceStatusCardState createState() => _PoliceStatusCardState();
}

class _PoliceStatusCardState extends State<PoliceStatusCard> {
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
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width * .95,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: AppColors.primaryColor.withOpacity(.2),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width *
                      .40, // Specify the width

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.item.imageUrls?.first ?? ''),
                      fit: BoxFit
                          .fill, // Adjust to cover to fill the box, keeping aspect ratio
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
                    createPublishChip(
                        _formatDateTime(widget.item.publishDateTime), context),
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
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.item.city ?? 'Unknown location',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text("Action Taken:",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    widget.item.reportStatusByPolice == null
                        ? "Awaiting"
                        : widget.item.reportStatusByPolice!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
