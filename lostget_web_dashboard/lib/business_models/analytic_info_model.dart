import 'package:flutter/material.dart';
enum AnalyticEnumOption{LOST_COUNT,FOUND,RECOVERED_RATE,USER_COUNT}
class AnalyticInfo {
  final String? svgSrc, title;
  final dynamic? count;
  final Color? color;
  final AnalyticEnumOption? analyticEnumOption;

  AnalyticInfo({
    this.svgSrc,
    this.title,
    this.count,
    this.color,
    this.analyticEnumOption,
  });
}

