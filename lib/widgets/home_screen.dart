import 'package:flutter/material.dart';
import 'package:matchpoint/models/static_data.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/widgets/common.dart';
import 'package:matchpoint/widgets/home_place_list.dart';
import 'package:matchpoint/widgets/sports_filter_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/location_provider.dart';
import 'disabled_permission_screen.dart';

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
        : locProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  children: [
                    _SearchPlaceBar(
                      outputCtrl: searchPlaceQuery,
                      onSubmit: (value) {
                        fetchPlacesList();
                      },
                    ),
                    _FilterBar(
                      selectedCategory: selectedCategory,
                      onPressed: _onPressedFilterBySports,
                    ),
                    Expanded(
                      child: placeProvider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : HomePlaceList(
                              places: placeProvider.getList,
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

class _FilterBar extends StatelessWidget {
  final SportsCategories selectedCategory;
  final Function() onPressed;
  const _FilterBar({required this.selectedCategory, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final locProvider = context.watch<LocationProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: IconWithText(
            icon: Icons.location_on_outlined,
            text: locProvider.currentLocation!.postalCode ?? "",
          ),
        ),
        Flexible(
          child: ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.filter_list),
            label: Text(selectedCategory == SportsCategories.all
                ? "Category"
                : selectedCategory.categoryString),
          ),
        ),
      ],
    );
  }
}

class _SearchPlaceBar extends StatelessWidget {
  final TextEditingController outputCtrl;
  final Function(String) onSubmit;

  const _SearchPlaceBar({required this.outputCtrl, required this.onSubmit});

  void _clearText() {
    outputCtrl.clear();
    onSubmit("");
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: outputCtrl,
      decoration: InputDecoration(
        hintText: "Search by court name",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: outputCtrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearText,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onSubmitted: onSubmit,
    );
  }
}
