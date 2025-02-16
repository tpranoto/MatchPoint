import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/providers/venue_provider.dart';
import 'package:matchpoint/widgets/place_detail_page.dart';
import 'package:matchpoint/widgets_new/home_venue_card.dart';
import 'package:provider/provider.dart';
import '../models/venue.dart';
import '../providers/place_provider.dart';
import '../widgets/common.dart';

class HomeVenueList extends StatefulWidget {
  final List<Venue> venues;
  final Position latLong;
  final SportsCategories selectedCat;

  final Future<void> Function() onRefresh;

  const HomeVenueList(
      {super.key,
      required this.venues,
      required this.latLong,
      required this.selectedCat,
      required this.onRefresh});

  @override
  State<HomeVenueList> createState() => _HomeVenueListState();
}

class _HomeVenueListState extends State<HomeVenueList> {
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_infiniteScrollHandler);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (venueProvider.getList.isEmpty) {
        await venueProvider.fetchVenues(widget.latLong, widget.selectedCat);
      }
    });
  }

  void _infiniteScrollHandler() {
    final venueProvider = context.read<VenueProvider>();

    if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent &&
        venueProvider.nextPageUrl != "") {
      venueProvider.fetchNextPageVenues();
    }
  }

  @override
  Widget build(BuildContext context) {
    final venueProvider = context.watch<VenueProvider>();

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: ListView.builder(
        controller: _scrollCtrl,
        itemCount: widget.venues.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.venues.length) {
            // return empty space when loading finished
            return venueProvider.isNextPageLoading
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
