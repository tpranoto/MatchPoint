import 'package:flutter/material.dart';
import 'package:matchpoint/models/category.dart';
import 'package:matchpoint/providers/place_provider.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final locProvider =
            Provider.of<LocationProvider>(context, listen: false);
        if (locProvider.latLong == null) {
          locProvider.getCurrentLocation().then((_) {
            final latLong = locProvider.latLong;
            if (latLong != null) {
              final placeProvider =
                  Provider.of<PlaceProvider>(context, listen: false);
              if (placeProvider.getList.isEmpty) {
                placeProvider.fetchPlaces(latLong, selectedCategory);
              }
            }
          });
        }
      }
    });
  }

  _onPressedFilterBySports() {
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

  fetchPlacesList() async {
    final locProvider = Provider.of<LocationProvider>(context, listen: false);
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    placeProvider.fetchPlaces(locProvider.latLong!, selectedCategory,
        searchName: searchPlaceQuery.text);
  }

  @override
  Widget build(BuildContext context) {
    final locProvider = context.watch<LocationProvider>();
    final placeProvider = context.watch<PlaceProvider>();

    return locProvider.permissionDenied
        ? DisabledPermissionPage()
        : locProvider.isLoading || locProvider.currentLocation == null
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
                    FilterBar(
                      selectedCategory: selectedCategory,
                      onPressed: _onPressedFilterBySports,
                      postalCode: locProvider.currentLocation!.postalCode!,
                    ),
                    Expanded(
                      child: placeProvider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : HomeVenueList(
                              venues: placeProvider.getList,
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
