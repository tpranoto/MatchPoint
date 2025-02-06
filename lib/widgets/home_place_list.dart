import 'package:flutter/material.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/widgets/place_detail_page.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
import '../providers/place_provider.dart';
import 'common.dart';

class HomePlaceList extends StatefulWidget {
  final List<Place> places;
  final Future<void> Function() onRefresh;

  const HomePlaceList(
      {super.key, required this.places, required this.onRefresh});

  @override
  State<HomePlaceList> createState() => _HomePlaceListState();
}

class _HomePlaceListState extends State<HomePlaceList> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_infiniteScrollListener);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_infiniteScrollListener);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _infiniteScrollListener() {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);

    if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent &&
        placeProvider.nextPageUrl != "") {
      placeProvider.fetchNextPagePlaces();
    }
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = context.watch<PlaceProvider>();
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollCtrl,
        itemCount: widget.places.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.places.length) {
            return placeProvider.isScrollLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(); // Empty space if not loading
          }

          final place = widget.places[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: ImageWithDefault(
                photoUrl: place.photoUrl,
                defaultAsset: "assets/matchpoint.png",
                size: 56,
              ),
              title: Text(place.name),
              subtitle: Text(
                "${place.sportCategory.categoryString} • ${place.distance.toStringAsPrecision(2)} mi",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "\$${place.priceInCent / 100}/hr",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaceDetailPage(place: place),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
