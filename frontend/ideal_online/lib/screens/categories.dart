import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/configs/catalog_controller.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/nav_bar.dart';
import 'package:ideal_online/widgets/product_grid.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Encapsulated state (not global)
  bool selected = false;
  String? selectedCategory;

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Dairy':
        return Icons.local_drink;
      case 'Bakery':
        return Icons.bakery_dining;
      case 'Flour':
        return Icons.grain;
      case 'Home Care':
        return Icons.cleaning_services;
      case 'Sweet & Platters':
        return Icons.cake;
      case 'Nursery':
        return Icons.baby_changing_station;
      case 'Snacks':
        return Icons.cookie;
      case 'Beverages':
        return Icons.local_cafe;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = CatalogController();

    return Scaffold(
      appBar: IdealAppBar(
        logoPath: 'assets/logo_nbg.png',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.toNamed("/login");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unselected State: Full Category Grid
              if (!selected) ...[
                const Text(
                  'All Categories',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: catalog.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final categoryName = catalog.categories[index];
                    final itemCount = catalog.getFilteredProducts(categoryName).length;

                    return _CategoryCard(
                      title: categoryName,
                      icon: _getCategoryIcon(categoryName),
                      itemCount: '$itemCount Items',
                      onTap: () {
                        setState(() {
                          selected = true;
                          selectedCategory = categoryName;
                        });
                      },
                    );
                  },
                ),
              ] else ...[
                // Selected State: Header with Back Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedCategory ?? 'Category',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          selected = false;
                          selectedCategory = null;
                        });
                      },
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text('All Categories'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Horizontal Category Selection Strip
                SizedBox(
                  height: 105,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catalog.categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final categoryName = catalog.categories[index];
                      final itemCount = catalog.getFilteredProducts(categoryName).length;

                      return _CategoryCard(
                        title: categoryName,
                        icon: _getCategoryIcon(categoryName),
                        itemCount: '$itemCount Items',
                        isSelected: categoryName == selectedCategory,
                        onTap: () {
                          setState(() {
                            selectedCategory = categoryName;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Filtered Products Display
                ProductGrid(
                  products: catalog.getFilteredProducts(selectedCategory ?? ''),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: IdealBottomNavBar(
        currentIndex: 1,
        onTap: (_) {},
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String itemCount;
  final VoidCallback onTap;
  final bool isSelected;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.itemCount,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.08) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Icon(
                icon,
                size: 24,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              itemCount,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}