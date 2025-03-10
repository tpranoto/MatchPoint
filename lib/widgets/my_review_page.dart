import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'main_scaffold.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';

class MyReviewPage extends StatelessWidget {
  final String profileId;
  const MyReviewPage(this.profileId, {super.key});

  @override
  Widget build(BuildContext context) {
    final reviewProv = context.watch<ReviewProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.indigo.shade100,
        title: Text(
          "My Reviews",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: MPFutureBuilder(
          future: reviewProv.loadUserReviews(profileId),
          onSuccess: (ctx, snapshot) {
            if (snapshot.hasError) {
              errorDialog(ctx, "${snapshot.error}");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (ctx) => MainScaffold(
                            startIndex: 2,
                          )),
                  (Route<dynamic> route) => false);
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: reviewProv.userReviewData.isEmpty
                  ? Center(child: Text("No reviews available"))
                  : Column(
                      spacing: 10,
                      children: [
                        ...reviewProv.userReviewData
                            .map((item) => _MyReviewCard(item)),
                      ],
                    ),
            );
          }),
    );
  }
}

class _MyReviewCard extends StatelessWidget {
  final Review review;
  const _MyReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(review.name),
        subtitle: Text(review.comment),
      ),
    );
  }
}
