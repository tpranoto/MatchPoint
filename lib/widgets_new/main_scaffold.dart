import 'package:flutter/material.dart';
import 'package:matchpoint/widgets/common.dart';
import 'package:matchpoint/widgets_new/profile_screen.dart';

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

  final List<Widget> _screens = [
    Placeholder(),
    Placeholder(),
    ProfileScreen(),
  ];

  final List<String> _screenTitle = [
    "Match Point",
    "My Reservations",
    "My Profile",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CenteredTitle(
          _screenTitle[_selectedIndex],
          size: 20,
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }
}
