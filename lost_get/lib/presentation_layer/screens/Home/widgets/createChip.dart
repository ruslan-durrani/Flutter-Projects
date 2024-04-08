
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_get/models/report_item.dart';

Widget createLostFoundChip(ReportItemModel item, context){
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(10),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10)),
      color: item.status!.contains("Found")
          ? Colors.green
          : Colors.red,
    ),
    child: Text(item.status ?? 'Unknown',
        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white,fontSize: 11)),
  );
}

Widget createPublishChip(String date, context){
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        color: Colors.black
    ),
    child: Text(date,
        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white,fontSize: 11)),
  );
}