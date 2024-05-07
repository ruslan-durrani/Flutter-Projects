import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:lost_get/business_logic_layer/AIMatchedReport/bloc/ai_matched_reports_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/report_status_provider.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/data_store_layer/repository/ai_report_item_repository.dart';
import 'package:lost_get/presentation_layer/screens/AI%20Matched%20Report/widgets/ai_report_button.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/createChip.dart';
import 'package:lost_get/presentation_layer/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../models/report_item.dart'; // Add intl package to your pubspec.yaml

class AIReportedItemCard extends StatefulWidget {
  final ReportItemModel item;
  final VoidCallback onTap;
  final AiMatchedReportsBloc aiBloc;

  const AIReportedItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.aiBloc,
  });

  @override
  _AIReportedItemCardState createState() => _AIReportedItemCardState();
}

class _AIReportedItemCardState extends State<AIReportedItemCard> {
  final AIReportItemRepository _aiReportItemRepository =
      AIReportItemRepository();
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
  void initState() {
    context
        .read<ReportStatusProvider>()
        .checkReportStatus(widget.item.id!, _aiReportItemRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 180,
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
                        .45, // Specify the width
                    // Match the card height or adjust as needed
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.item.imageUrls?.first ?? ''),
                        fit: BoxFit
                            .cover, // Adjust to cover to fill the box, keeping aspect ratio
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
                          _formatDateTime(widget.item.publishDateTime),
                          context),
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
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context)
                              .style, // Uses the default text style of your app
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Match Percentage: ',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight:
                                        FontWeight.bold)), // Regular text
                            TextSpan(
                                text:
                                    '${widget.item.matchPercentage}%', // Dynamic data
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight
                                        .normal) // Making the percentage bold
                                ),
                          ],
                        ),
                      ),
                      Consumer<ReportStatusProvider>(
                        builder: (context, provider, child) {
                          if (provider.isAccepted == null) {
                            return const SpinKitFadingCircle(
                              color: AppColors.primaryColor,
                              size: 10,
                            );
                          }
                          return provider.isAccepted == true
                              ? aiButton(
                                  "ACCEPTED", () {}, Colors.green, Colors.white)
                              : Row(children: [
                                  aiButton("Decline", () {
                                    alertDialog(
                                      context,
                                      "Are you sure that you want to mark this report as not yours?",
                                      "Decline Report",
                                      "No",
                                      "Decline",
                                      () {
                                        Navigator.pop(context);
                                      },
                                      () {
                                        widget.aiBloc.add(
                                            AIMatchReportDeclineEvent(
                                                reportId: widget.item.id!));
                                        Navigator.pop(context);
                                      },
                                    );
                                  }, Colors.red, AppColors.lightPurpleColor),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  aiButton("Accept", () {
                                    alertDialog(
                                      context,
                                      "Are you sure that you want to mark this report as yours?",
                                      "Accept Report",
                                      "No",
                                      "Accept",
                                      () {
                                        Navigator.pop(context);
                                      },
                                      () {
                                        widget.aiBloc.add(
                                            AIMatchReportAcceptedEvent(
                                                reportId: widget.item.id!));
                                        Navigator.pop(context);
                                      },
                                    );
                                  }, AppColors.darkPrimaryColor,
                                      AppColors.lightPurpleColor),
                                ]);
                        },
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
