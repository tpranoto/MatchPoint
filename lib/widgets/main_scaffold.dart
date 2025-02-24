import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_reservation_page.dart';
import 'profile_screen.dart';

class MainScaffold extends StatefulWidget {
  final int startIndex;
  const MainScaffold({super.key, this.startIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.startIndex;
  }

  Future<String> _fetchProfileId() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchProfileId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || snapshot.data == '') {
          return Scaffold(
            body: Center(child: Text("Please log in to view reservations.")),
          );
        }

        final String profileId = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              ["Match Point", "My Reservations", "My Profile"][_selectedIndex],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: [
            HomeScreen(),
            MyReservationPage(profileId: profileId),
            ProfileScreen(),
          ]
          [_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Reservations'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
            ],
          ),
        );
      },
    );
  }
}
