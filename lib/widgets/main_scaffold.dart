import 'package:flutter/material.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/home_screen.dart';
import 'package:matchpoint/widgets/profile_screen.dart';
import 'package:matchpoint/widgets/reservations_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ReservationsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: navBar(),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          AuthService().signOut();
        },
        child: Icon(Icons.back_hand),
      ),
    );
  }

  Widget navBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (idx) => _onItemTapped(idx),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.article,
          ),
          label: 'Reservations',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle,
          ),
          label: 'Account',
        )
      ],
    );
  }
}
