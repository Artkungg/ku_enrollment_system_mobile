import 'package:flutter/material.dart';

class BottomMenuBar extends StatefulWidget {
  const BottomMenuBar({super.key});

  @override
  State<BottomMenuBar> createState() => _ButtomMenuBarState();
}

class _ButtomMenuBarState extends State<BottomMenuBar> {
  int _selectedIndex = 0;
  Color c1 = const Color(0xFF2E2E2E);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.greenAccent,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: "School",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Account",
        ),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
