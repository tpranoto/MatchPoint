import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/static_data.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/services/location.dart';
import 'package:matchpoint/widgets/sports_filter_dialog.dart';
import 'package:matchpoint/widgets/place_detail_page.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
import 'disabled_permission_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchPlaceQuery = "";
  SportsCategories selectedCategory = SportsCategories.all;

  bool _isLocLoading = true;

  Position? latLong;
  Placemark? currentLocation;

  @override
  void initState() {
    super.initState();

    if (mounted && latLong == null) {
      LocationService().getPermission().then((permission) {
        if (permission == LocationPermission.deniedForever ||
            permission == LocationPermission.denied) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DisabledPermissionPage()),
          );
        }

        LocationService().getCurrentLocation().then((curr) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              currentLocation = curr["Placemark"];
              latLong = curr["Position"];
              _isLocLoading = false;
            });

            Future.delayed(Duration.zero, () {
              final prov = Provider.of<PlaceProvider>(context, listen: false);
              if (prov.getList.isEmpty) {
                prov.fetchPlaces(latLong!, SportsCategories.all);
              }
            });
          });
        });
      });
    }
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = context.watch<PlaceProvider>();
    // List<Place> filteredCourts = placeProvider.getList
    //     .where((place) =>
    //         (selectedSportsFilter == "All" ||
    //             place.sportCategory.categoryString == selectedSportsFilter) &&
    //         (searchPlaceQuery.isEmpty ||
    //             place.name
    //                 .toLowerCase()
    //                 .contains(searchPlaceQuery.toLowerCase())))
    //     .toList();
    return _isLocLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: [
                _SearchPlaceBar(onSearch: (value) {
                  setState(() {
                    searchPlaceQuery = value;
                  });
                }),
                _filterBar(),
                Expanded(
                  child: placeProvider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : PlaceList(places: placeProvider.getList),
                ),
              ],
            ),
          );
  }

  Widget _filterBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(Icons.location_on_outlined),
            Text(currentLocation!.postalCode ?? ""),
          ],
        ),
        Flexible(
          child: ElevatedButton.icon(
            onPressed: _onPressedFilterBySports,
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
  final Function(String) onSearch;

  const _SearchPlaceBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search by court name",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: onSearch,
    );
  }
}

class PlaceList extends StatelessWidget {
  final List<Place> places;

  const PlaceList({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image(
                height: 56,
                width: 56,
                fit: BoxFit.fill,
                image: place.photoUrl != null
                    ? NetworkImage(place.photoUrl!)
                    : AssetImage("assets/matchpoint.png"),
              ),
            ),
            title: Text(place.name),
            subtitle: Text(
                "${place.sportCategory.categoryString} - ${place.distance.toStringAsPrecision(2)} mi"),
            trailing: Text("\$${place.priceInCent / 100}/hr"),
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
    );
  }
}
