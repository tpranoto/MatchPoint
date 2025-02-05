import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/models/static_data.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/services/location.dart';
import 'package:matchpoint/widgets/filter_dialog.dart';
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
  String selectedSportsFilter = "All";

  bool _isLoading = true;
  Placemark? currentLocation;

  @override
  void initState() {
    super.initState();
    LocationService().getPermission().then((permission) {
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DisabledPermissionPage()),
        );
      }

      LocationService().getCurrentLocation().then((curr) {
        setState(() {
          currentLocation = curr;
          _isLoading = false;
        });
      });
    });
  }

  _onPressedFilterBySports() {
    showFilterDialog(
      context,
      "Filter by specific sport",
      sportsCategoriesToList(),
      selectedSportsFilter,
      (value) {
        setState(() {
          selectedSportsFilter = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final placeProvider = context.watch<PlaceProvider>();
    List<Place> filteredCourts = placeProvider.getList
        .where((place) =>
            (selectedSportsFilter == "All" ||
                place.sportCategory.categoryString == selectedSportsFilter) &&
            (searchPlaceQuery.isEmpty ||
                place.name
                    .toLowerCase()
                    .contains(searchPlaceQuery.toLowerCase())))
        .toList();
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              Text(currentLocation!.toString()),
              _SearchPlaceBar(onSearch: (value) {
                setState(() {
                  searchPlaceQuery = value;
                });
              }),
              ElevatedButton.icon(
                onPressed: _onPressedFilterBySports,
                icon: const Icon(Icons.filter_list),
                label: const Text("Category"),
              ),
              Expanded(
                child: PlaceList(places: filteredCourts),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search by court name",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onSearch,
      ),
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
          margin: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(place.name),
            subtitle: Text(
                "${place.sportCategory.categoryString} - ${place.address}"),
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
