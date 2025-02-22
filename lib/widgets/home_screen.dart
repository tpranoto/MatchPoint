import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'disabled_permission_page.dart';
import 'home_screen_content.dart';
import '../providers/location_provider.dart';

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

    return MPStreamBuilder(
        stream: locProvider.locationStream,
        streamContinuation: () {
          if (locProvider.currentLocation != null) {
            locProvider.streamCurrentLocation();
          }
        },
        onSuccess: (context, snapshot) {
          if (locProvider.permissionDenied) {
            return DisabledPermissionPage();
          }

          if (locProvider.currentLocation == null) {
            errorDialog(context, "error getting location, please try again");
            return DisabledPermissionPage();
          }

          return HomeScreenContent();
        });
  }
}
