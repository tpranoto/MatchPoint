import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:matchpoint/providers/location_provider.dart';
import 'package:matchpoint/providers/place_provider.dart';
import 'package:matchpoint/providers/profile_provider.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/services/firestore.dart';
import 'package:matchpoint/services/place.dart';
import 'package:matchpoint/widgets/login_page.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => AuthService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AppProfileProvider(firestoreService: FirestoreService()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LocationProvider(geolocator: GeolocatorPlatform.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaceProvider(placeService: PlaceService()),
        ),
      ],
      child: MaterialApp(
        title: 'Match Point',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
