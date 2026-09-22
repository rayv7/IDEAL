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
        Navigator.pushReplacementNamed(context, '/home');
        break;  
      case 3:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 4:
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
            color: secondaryColor,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
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
              title: const Text(''),
              selectedColor: primaryColor,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.grid_view_outlined),
              activeIcon: const Icon(Icons.grid_view),
              title: const Text(''),
              selectedColor: secondaryColor,
            ),
            SalomonBottomBarItem(
              icon: Container(
                width: 42,  // Increase size here (default icon size is ~24)
                height: 42,
                padding: const EdgeInsets.all(4.0), // Optional inner padding
                decoration: BoxDecoration(
                  color: Colors.white, // Background color behind logo
                  shape: BoxShape.circle, // Makes the container fully round
                  // OR use rounded rectangle corners instead of a circle:
                  // borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50), // Clips image to rounded edges
                  child: Image.asset(
                    'assets/Fikar_logo2.png', 
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              title: const Text('FIKAR')
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              title: const Text(''),
              selectedColor: auxilaryColor,
            ),
            SalomonBottomBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              title: const Text(''),
              selectedColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}