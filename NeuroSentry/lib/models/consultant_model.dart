import 'package:flutter/material.dart';
import 'package:mental_healthapp/models/rating_and_review_model.dart';

class ConsultantModel {
  final String name;
  final String type;
  final String description;
  Color color;
  List<RatingAndReviewModel> ratingsAndReview;

  ConsultantModel({
    required this.name,
    required this.type,
    required this.description,
    this.color = Colors.blue,
    this.ratingsAndReview = const [],
  });

  factory ConsultantModel.fromMap(Map<String, dynamic> map) {
    return ConsultantModel(
      name: map['name'],
      type: map['type'],
      description: map['description'],
      color: Color(
        map['color'],
      ),
      ratingsAndReview: map['ratingsAndReviews'] == null
          ? []
          : List<RatingAndReviewModel>.from(
              map['ratingsAndReviews'].map(
                (x) => RatingAndReviewModel.fromMap(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'color': color
          .value, // Assuming Color has a property named 'value' that represents its value
      'ratingsAndReview': List<dynamic>.from(
        ratingsAndReview.map(
          (x) => x.toMap(),
        ),
      ),
    };
  }
}
