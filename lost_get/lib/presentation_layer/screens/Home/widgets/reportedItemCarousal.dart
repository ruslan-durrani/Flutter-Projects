import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lost_get/presentation_layer/screens/Home/widgets/reportedItemCard.dart';
import '../../../../models/report_item.dart';

class ReportedItemsCarousel extends StatelessWidget {
  final List<ReportItemModel> reportedItems;
  final Function(ReportItemModel) onTap;

  const ReportedItemsCarousel({
    Key? key,
    required this.reportedItems,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: false,
        aspectRatio: 1,
        padEnds: true,
        enlargeCenterPage: false,
        viewportFraction: 0.8,
      ),
      items: reportedItems.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.only(right: 5),
              child: ReportedItemCard(
                item: item,
                onTap: () => onTap(item),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
