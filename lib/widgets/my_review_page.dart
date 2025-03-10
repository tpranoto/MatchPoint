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
        title: const Text("My Reviews",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: MPFutureBuilder(
          future: reviewProv.loadUserReviews(profileId),
          onSuccess: (ctx, snapshot) {
            if (snapshot.hasError) {
              errorDialog(ctx, "${snapshot.error}");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (ctx) => const MainScaffold(startIndex: 2)),
                      (Route<dynamic> route) => false);
            }
            return Padding(
              padding: const EdgeInsets.all(15),
              child: reviewProv.userReviewData.isEmpty
                  ? const Center(
                  child: Text("No reviews available",
                      style: TextStyle(fontSize: 16, color: Colors.grey)))
                  : ListView.builder(
                  itemCount: reviewProv.userReviewData.length,
                  itemBuilder: (_, i) =>
                      _MyReviewCard(reviewProv.userReviewData[i])),
            );
          },
        ),
      ),
    );
  }
}

class _MyReviewCard extends StatelessWidget {
  final Review review;
  const _MyReviewCard(this.review);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [CircleAvatar(
                  backgroundColor: Colors.indigo.shade100,
                  child: Text(review.name[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(review.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              Text(review.createdAt.toLocal().toString().split(' ')[0],
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ]),
            const SizedBox(height: 8),
            RatingStar(
                rating: review.rating.toDouble(), count: 5, useNumeric: true),
            const SizedBox(height: 6),
            Text(review.comment,
                style: const TextStyle(fontSize: 14, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
