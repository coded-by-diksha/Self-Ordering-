import 'package:flutter/material.dart';
import 'package:spicebite/pages/Dashboard.dart';
import 'package:spicebite/pages/OrderHistory.dart';
import 'package:spicebite/pages/Profile/ProfilePage.dart';

class Navigation extends StatefulWidget {
  final int selectedIndex;
  final Widget? currentPage;  // Accepts any sub-page
  const Navigation({super.key, this.currentPage, required this.selectedIndex});

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  // Add indexes to all BottomNavigationBarItem(s)
  // and provide a method to programmatically select a tab by index

  /// Returns the index of the currently selected tab.
  int get selectedIndex => _selectedIndex;

  /// Programmatically select a tab by index.
  void selectTab(int index) {
    if (index < 0 || index >= _mainScreens.length) return;
    if (index == _selectedIndex) return;
    
    setState(() => _selectedIndex = index);
  }

  /// Returns the index for a given BottomNavigationBarItem label.
  int? getIndexByLabel(String label) {
    const labels = ['Home', 'Orders', 'Profile'];
    final idx = labels.indexOf(label);
    return idx != -1 ? idx : null;
  }

  // Main screens (for bottom nav items)
  static final List<Widget> _mainScreens = <Widget>[
     Dashboard(),
     OrderHistory(),
     ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Prevent rebuild if same tab
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Ensure initial tab is set from widget.selectedIndex
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Show sub-page if provided, else show main screen
      body: widget.currentPage ?? _mainScreens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.brown[700],
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Orders'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}