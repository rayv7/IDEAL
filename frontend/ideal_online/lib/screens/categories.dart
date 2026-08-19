import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/nav_bar.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IdealAppBar(
        logoPath: 'assets/logo_nbg.png',
        onSearchSubmitted: (query) {
          print('Search submitted: $query');
          // Handle search submission
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.toNamed("/home");
            },
          ),
        ]
      ),
      bottomNavigationBar: IdealBottomNavBar(
        currentIndex: 1,
        onTap: (index) {}
      ),
    );
  }
}