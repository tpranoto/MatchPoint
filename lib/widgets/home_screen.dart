import 'package:flutter/material.dart';
import 'package:matchpoint/models/static_data.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/widgets/sports_filter_dialog.dart';
import 'package:matchpoint/widgets/place_detail_page.dart';
import 'package:provider/provider.dart';
import '../models/place.dart';
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
            ? Center(
                child: CircularProgressIndicator(),
              )
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
                    _filterBar(),
                    Expanded(
                      child: placeProvider.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : PlaceList(
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

  Widget _filterBar() {
    final locProvider = context.watch<LocationProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 8,
          children: [
            Icon(Icons.location_on_outlined),
            Text(locProvider.currentLocation?.postalCode ?? ""),
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

class PlaceList extends StatefulWidget {
  final List<Place> places;
  final Future<void> Function() onRefresh;

  const PlaceList({super.key, required this.places, required this.onRefresh});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
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
