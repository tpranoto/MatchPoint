import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_reservation_screen.dart';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        MyReservationScreen(),
        ProfileScreen(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'Reservations'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      ),
    );
  }
}
