import 'package:flutter_project/practice/features/products/domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    super.rating,

    super.comment,

    super.date,

    super.reviewerName,

    super.reviewerEmail,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'],

      comment: json['comment'],

      date: json['date'],

      reviewerName: json['reviewerName'],

      reviewerEmail: json['reviewerEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,

      'comment': comment,

      'date': date,

      'reviewerName': reviewerName,

      'reviewerEmail': reviewerEmail,
    };
  }
}
