import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'disabled_permission_page.dart';
import 'home_screen_content.dart';
import '../providers/location_provider.dart';
import '../providers/venue_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final locProvider = context.read<LocationProvider>();
    if (locProvider.currentLocation == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await locProvider.loadCurrentLocation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locProvider = context.watch<LocationProvider>();
    final venueProvider = context.watch<VenueProvider>();

    return StreamBuilder<LocationData>(
        stream: locProvider.locationStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            if (locProvider.currentLocation != null) {
              locProvider.streamCurrentLocation();
            }
            return CenteredLoading();
          }

          if (snapshot.hasError) {
            errorDialog(context, snapshot.error.toString());
            return SizedBox.shrink();
          }

          if (!snapshot.hasData || locProvider.permissionDenied) {
            return DisabledPermissionPage();
          }
          return StreamBuilder(
            stream: venueProvider.venueStream,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                if (venueProvider.getList.isNotEmpty) {
                  venueProvider.streamCurrentVenues();
                }
                return CenteredLoading();
              }

              if (snapshot.hasError) {
                errorDialog(context, snapshot.error.toString());
                return SizedBox.shrink();
              }
              return HomeScreenContent();
            },
          );
        });
  }
}
