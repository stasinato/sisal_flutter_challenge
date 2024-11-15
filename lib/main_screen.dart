import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: navigationShell,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer), label: 'Gazzetta'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Instagram'),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_album), label: 'Galleria'),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => navigationShell.goBranch(index),
      ),
    );
  }
}
