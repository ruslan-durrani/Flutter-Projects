import 'package:flutter/material.dart';
import 'package:mental_healthapp/shared/enums/question_type.dart';

class ArticleModel {
  final String title;
  final String description;
  final IconData iconData;
  final Color color;
  final String videoUrl;
  final QuestionType articleType;
  String subTitle;

  ArticleModel({
    required this.title,
    required this.description,
    required this.iconData,
    required this.color,
    required this.videoUrl,
    required this.articleType,
    this.subTitle = "Read More",
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'iconData': iconData.codePoint,
      'color': color.value,
      'videoUrl': videoUrl,
      'articleType': articleType.type,
      'subTitle': subTitle,
    };
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      title: map['title'],
      description: map['description'],
      iconData: IconData(map['iconData'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
      videoUrl: map['videoUrl'],
      articleType: QuestionType.fromString(map['articleType']),
      subTitle: map['subTitle'],
    );
  }
}
