import 'package:flutter/material.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/providers/venue_provider.dart';
import 'package:matchpoint/widgets/common.dart';
import 'package:matchpoint/widgets/disabled_permission_page.dart';
import 'package:matchpoint/widgets/home_navigation.dart';
import 'package:matchpoint/widgets/home_venue_list.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchPlaceQuery = TextEditingController();
  SportsCategories selectedCategory = SportsCategories.all;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final locProvider = context.read<LocationProvider>();
        await locProvider.loadCurrentLocation();
        final venueProvider = context.read<VenueProvider>();
        if (venueProvider.getList.isEmpty) {
          await venueProvider.fetchVenues(
              locProvider.latLong, selectedCategory);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locProvider = context.watch<LocationProvider>();
    final venueProvider = context.watch<VenueProvider>();

    fetchPlacesList() async {
      venueProvider.fetchVenues(locProvider.latLong, selectedCategory,
          searchName: searchPlaceQuery.text);
    }

    onPressedFilterBySports() {
      showSportsFilterDialog(
        context,
        "Filter by specific sport",
        selectedCategory,
        (value) {
          setState(() {
            selectedCategory = value;
          });
          fetchPlacesList();
        },
      );
    }

    return locProvider.permissionDenied
        ? DisabledPermissionPage()
        : locProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  children: [
                    SearchVenueBar(
                      outputCtrl: searchPlaceQuery,
                      selectedCat: selectedCategory,
                      onSubmit: (value) {
                        fetchPlacesList();
                      },
                    ),
                    SizedBox(height: 10),
                    FilterBar(
                      selectedCategory: selectedCategory,
                      onPressed: onPressedFilterBySports,
                      postalCode: locProvider.currentLocation.postalCode!,
                    ),
                    Expanded(
                      child: venueProvider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : HomeVenueList(
                              venues: venueProvider.getList,
                              onRefresh: () async {
                                fetchPlacesList();
                              },
                            ),
                    ),
                  ],
                ),
              );
  }
}
