class RatingAndReviewModel {
  String userName;
  int rating;
  String review;
  RatingAndReviewModel({
    required this.rating,
    required this.review,
    required this.userName,
  });

  factory RatingAndReviewModel.fromMap(Map map) {
    return RatingAndReviewModel(
      rating: map['rating'],
      review: map['review'],
      userName: map['userName'],
    );
  }
  toMap() {
    return {
      'userName': userName,
      'rating': rating,
      'review': review,
    };
  }
}
