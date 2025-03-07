import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'widgets/entry.dart';
import 'providers/location_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/venue_provider.dart';
import 'providers/reservation_provider.dart';

void main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.env["SQUARESPACE_API_KEY"] ?? "";

    return MultiProvider(
      providers: [
        Provider(
          create: (ctx) => AppAuthProvider(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileProvider(FirebaseFirestore.instance),
        ),
        Provider(
          create: (ctx) => LocationProvider(GeolocatorPlatform.instance),
        ),
        ChangeNotifierProvider(
          create: (ctx) => VenueProvider(apiKey),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReservationProvider(FirebaseFirestore.instance),
        ),
        Provider(
          create: (ctx) => NotificationProvider(FirebaseMessaging.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Match Point',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const Entry(),
      ),
    );
  }
}
