import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_venue_card.dart';
import 'common.dart';
import '../models/venue.dart';
import '../providers/venue_provider.dart';

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
            return venueProvider.isNextPageLoading
                ? CenteredLoading()
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
