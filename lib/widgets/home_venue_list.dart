import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/providers/venue_provider.dart';
import 'package:matchpoint/widgets/venue_detail_page.dart';
import 'package:matchpoint/widgets/home_venue_card.dart';
import 'package:provider/provider.dart';
import '../models/venue.dart';
import '../providers/place_provider.dart';
import 'common.dart';

class HomeVenueList extends StatefulWidget {
  final List<Venue> venues;

  final Future<void> Function() onRefresh;

  const HomeVenueList(
      {super.key, required this.venues, required this.onRefresh});

  @override
  State<HomeVenueList> createState() => _HomeVenueListState();
}

class _HomeVenueListState extends State<HomeVenueList> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_infiniteScrollHandler);
  }

  void _infiniteScrollHandler() {
    final venueProvider = context.read<PlaceProvider>();

    if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent &&
        venueProvider.nextPageUrl != "") {
      venueProvider.fetchNextPagePlaces();
    }
  }

  @override
  Widget build(BuildContext context) {
    final venueProvider = context.watch<PlaceProvider>();

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollCtrl,
        itemCount: widget.venues.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.venues.length) {
            // return empty space when loading finished
            return venueProvider.isScrollLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox();
          }

          return HomeVenueCard(widget.venues[index]);
        },
      ),
    );
  }

  @override
  void dispose() {
    if (mounted) {
      _scrollCtrl.removeListener(_infiniteScrollHandler);
      _scrollCtrl.dispose();
    }
    super.dispose();
  }
}
