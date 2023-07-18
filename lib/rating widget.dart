import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {

  final double rating;
  final double starSize;
  final Color unselectedStarColor;

  const StarRating({super.key,
    required this.rating,
    this.starSize = 20.0,
    this.unselectedStarColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color(0xFFFFD22A);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floorToDouble() ? Icons.star : Icons.star_border,
          size: starSize,
          color: index < rating.floorToDouble() ? myColor : unselectedStarColor,
        );
      }),
    );
  }
}