import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/controllers/catalog_controller.dart';
import 'package:ideal_online/controllers/cart_controller.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/nav_bar.dart';
import 'package:ideal_online/widgets/product_grid.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
    final catalog = Get.put(CatalogController());
    final cartController = Get.put(CartController());

    return Scaffold(
      appBar: IdealAppBar(
        logoPath: 'assets/logo_nbg.png',
        onSearchSubmitted: (query) {
          Get.snackbar("Coming soon!!!", "Feature currently unavailable");
        },
        actions: [
          Obx(() => Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Get.toNamed('/cart');
                    },
                  ),
                  if (cartController.totalItemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartController.totalItemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!selected) ...[
                const Text(
                  'All Categories',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: catalog.categories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.0,
                        mainAxisSpacing: 12.0,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final categoryName = catalog.categories[index];
                        final itemCount =
                            catalog.getFilteredProducts(categoryName).length;

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
                    )),
              ] else ...[
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
                SizedBox(
                  height: 105,
                  child: Obx(() => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: catalog.categories.length,
                        itemBuilder: (context, index) {
                          final categoryName = catalog.categories[index];
                          final itemCount =
                              catalog.getFilteredProducts(categoryName).length;

                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            child: _CategoryCard(
                              title: categoryName,
                              icon: _getCategoryIcon(categoryName),
                              itemCount: '$itemCount Items',
                              isSelected: categoryName == selectedCategory,
                              onTap: () {
                                setState(() {
                                  selectedCategory = categoryName;
                                });
                              },
                            ),
                          );
                        },
                      )),
                ),
                const SizedBox(height: 20),
                ProductGrid(
                  selectedCategory: selectedCategory ?? '',
                  onAddToCart: (product) {
                    cartController.addToCart(product);
                    Get.snackbar(
                      'Added to Cart',
                      '${product['name']} added to your cart',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 1),
                    );
                  },
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
          color:
              isSelected ? primaryColor.withOpacity(0.08) : Colors.grey[100],
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