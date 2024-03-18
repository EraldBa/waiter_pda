import 'package:flutter/material.dart';
import 'package:waiter_pda/app/components/orders_screen.dart';
import 'package:waiter_pda/app/components/settings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const route = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> _homePageList = [
    OrderScreen(),
    SettingsScreen(),
  ];

  static const List<Widget> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.list_alt),
      label: 'Orders',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  int _currentIndex = 0;

  void _updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homePageList[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        destinations: _destinations,
        onDestinationSelected: _updateIndex,
      ),
    );
  }
}
