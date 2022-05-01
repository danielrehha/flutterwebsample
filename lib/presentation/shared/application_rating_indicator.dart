import 'package:allbert_cms/domain/entities/entity_customer_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ApplicationRatingIndicator extends StatelessWidget {
  const ApplicationRatingIndicator(
      {Key key, this.ratings, this.avgRating, @required this.size})
      : super(key: key);

  final List<CustomerReview> ratings;
  final double avgRating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: avgRating ?? getAvgRating(ratings: ratings),
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: size,
      direction: Axis.horizontal,
    );
  }

  double getAvgRating({@required List<CustomerReview> ratings}) {
    if (ratings == null || ratings.isEmpty) {
      return 0.0;
    }
    double avg = 0.0;
    for (var rating in ratings) {
      avg += rating.rating;
    }
    avg /= ratings.length;
    return avg;
  }
}
