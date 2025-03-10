import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingStar extends StatelessWidget {
  final double rating;
  final int count;
  final double size;
  final bool isCentered;
  final bool useNumeric;
  const RatingStar(
      {super.key,
      required this.rating,
      required this.count,
      this.size = 30.0,
      this.isCentered = false,
      this.useNumeric = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
      spacing: 5,
      children: [
        useNumeric ? Text(rating.toStringAsPrecision(2)) : SizedBox.shrink(),
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: size,
        ),
        useNumeric
            ? Text(
                "($count)",
                style: TextStyle(fontSize: 10),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class RatingBarInput extends StatefulWidget {
  final Function(double) onRatingChange;

  const RatingBarInput(this.onRatingChange, {super.key});

  @override
  State<RatingBarInput> createState() => _RatingBarInputState();
}

class _RatingBarInputState extends State<RatingBarInput> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: 0,
      minRating: 1,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: widget.onRatingChange,
    );
  }
}
