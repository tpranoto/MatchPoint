import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import '../models/reservation.dart';
import '../models/review.dart';
import '../providers/profile_provider.dart';
import '../providers/reservation_provider.dart';
import '../providers/review_provider.dart';

class ReviewDialog extends StatefulWidget {
  final Reservation rsv;
  final String name;
  const ReviewDialog(this.rsv, this.name, {super.key});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  final TextEditingController ctrl = TextEditingController();
  int ratingsGiven = 0;

  onRatingChange(double newRating) {
    setState(() {
      ratingsGiven = newRating.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Text("Review Your Reservation"),
                Flexible(child: RatingBarInput(onRatingChange)),
                Flexible(
                  child: _CommentInput(ctrl),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SquaredButton(
                        text: "Cancel",
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    SquaredButton(
                        text: "Submit",
                        onPressed: ratingsGiven < 1
                            ? null
                            : () async {
                                await context
                                    .read<ReviewProvider>()
                                    .addMyNewReview(Review(
                                        venueId: widget.rsv.venueId,
                                        profileId: widget.rsv.profileId,
                                        rsvId: widget.rsv.rsvId!,
                                        rating: ratingsGiven,
                                        comment: ctrl.text,
                                        name: widget.name,
                                        createdAt: DateTime.now()));
                                await context
                                    .read<ProfileProvider>()
                                    .incrReviews();
                                await context
                                    .read<ReservationProvider>()
                                    .userReservationReviewed(widget.rsv.rsvId!);
                                Navigator.of(context).pop();
                              })
                  ],
                ),
              ],
            )));
  }
}

class _CommentInput extends StatelessWidget {
  final TextEditingController ctrl;
  const _CommentInput(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.url,
      controller: ctrl,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Comment",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
