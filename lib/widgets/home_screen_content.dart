import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'home_navigation.dart';
import 'home_venue_list.dart';
import '../models/category.dart';
import '../providers/location_provider.dart';
import '../providers/venue_provider.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  TextEditingController searchPlaceQuery = TextEditingController();
  SportsCategories selectedCategory = SportsCategories.all;

  fetchVenuesList() async {
    final locProvider = context.read<LocationProvider>();
    final venueProvider = context.read<VenueProvider>();
    await venueProvider.fetchVenues(locProvider.latLong, selectedCategory,
        searchName: searchPlaceQuery.text);
  }

  onFilterSelected(value) {
    setState(() {
      selectedCategory = value;
    });
    fetchVenuesList();
  }

  @override
  void initState() {
    super.initState();

    final venueProvider = context.read<VenueProvider>();
    if (venueProvider.getList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        venueProvider.fetchVenues(
            context.read<LocationProvider>().latLong, selectedCategory);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locProvider = context.watch<LocationProvider>();
    final venueProvider = context.watch<VenueProvider>();

    return MPStreamBuilder(
        stream: venueProvider.venueStream,
        streamContinuation: () {
          if (venueProvider.getList.isNotEmpty) {
            venueProvider.streamCurrentVenues();
          }
        },
        onSuccess: (ctx, snapshot) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                SearchVenueBar(
                  outputCtrl: searchPlaceQuery,
                  selectedCat: selectedCategory,
                  onSubmit: (value) {
                    fetchVenuesList();
                  },
                ),
                SizedBox(height: 10),
                FilterBar(
                  selectedCategory: selectedCategory,
                  onFilterSelected: onFilterSelected,
                  postalCode: locProvider.currentLocation!.postalCode!,
                ),
                SizedBox(height: 5),
                Expanded(
                  child: HomeVenueList(
                    venues: venueProvider.getList,
                    onRefresh: () async {
                      venueProvider.resetVenues();
                      fetchVenuesList();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
