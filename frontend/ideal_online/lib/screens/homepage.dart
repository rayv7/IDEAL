import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/configs/catalog_controller.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/nav_bar.dart';


class IdealMinimartHome extends StatefulWidget {
  const IdealMinimartHome({super.key});

  @override
  State<IdealMinimartHome> createState() => _IdealMinimartHomeState();
}



class _IdealMinimartHomeState extends State<IdealMinimartHome> {
  final CatalogController _catalogController = CatalogController();
  String selectedCategory = 'Dairy';

  int _currentIndex = 0;
  final List<Widget> _pages = const [
    Center(child: Text('Home Content')),
    Center(child: Text('Categories Content')),
    Center(child: Text('Cart Content')),
    Center(child: Text('Account Content')),
  ];

  @override
  Widget build(BuildContext context) {
    // Get products for the currently clicked category
    final filteredProducts = _catalogController.getFilteredProducts(
      selectedCategory,
    );

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
              Get.toNamed("/login");
            },
          ),
        ]
      ),
      bottomNavigationBar: IdealBottomNavBar(
        currentIndex: 0,
        onTap: (index) {}
      ),
      body:
        SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Promo Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Order now and get 10% off!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            // Categories Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

            // Category Horizontal List
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _catalogController.categories.length,
                itemBuilder: (context, index) {
                  final categoryName = _catalogController.categories[index];
                  final isSelected = categoryName == selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(categoryName),
                      selected: isSelected,
                      selectedColor: Colors.green,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = categoryName;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // Digital Aisles Title Header
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Digital Aisles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Product Grid
            filteredProducts.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No products found in this category.'),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      final imagePath = product['image'] ?? '';

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey.shade100,
                                child: imagePath.isNotEmpty
                                    ? Image.asset(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.image,
                                                  color: Colors.grey,
                                                ),
                                      )
                                    : const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product['name'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product['price'] ?? '',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
