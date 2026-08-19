import 'package:flutter/material.dart';
import 'package:ideal_online/configs/colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class IdealBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const IdealBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _handleNavigation(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/categories');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: SalomonBottomBar(
          currentIndex: currentIndex,
          onTap: (index) {
            _handleNavigation(context, index);
            onTap(index);
          },
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey[600],
          items: [
            SalomonBottomBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              title: const Text('Home'),
              selectedColor: primaryColor,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.grid_view_outlined),
              activeIcon: const Icon(Icons.grid_view),
              title: const Text('Categories'),
              selectedColor: secondaryColor,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              title: const Text('Cart'),
              selectedColor: auxilaryColor,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              title: const Text('Profile'),
              selectedColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}