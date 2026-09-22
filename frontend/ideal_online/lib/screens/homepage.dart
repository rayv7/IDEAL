import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/configs/catalog_controller.dart';
import 'package:ideal_online/configs/colors.dart';
import 'package:ideal_online/controllers/cart_controller.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/nav_bar.dart';
import 'package:ideal_online/widgets/product_grid.dart';
import 'package:ideal_online/widgets/promo_card.dart';


class IdealMinimartHome extends StatefulWidget {
  const IdealMinimartHome({super.key});

  @override
  State<IdealMinimartHome> createState() => _IdealMinimartHomeState();
}



class _IdealMinimartHomeState extends State<IdealMinimartHome> {
  final CatalogController _catalogController = CatalogController();
  final CartController cartController = Get.put(CartController());
  String selectedCategory = 'Dairy';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _catalogController.getFilteredProducts(
      selectedCategory,
    );

    return Scaffold(
      appBar: IdealAppBar(
        logoPath: 'assets/logo_nbg.png',
        onSearchSubmitted: (query) {
          Get.snackbar("Coming soon!!!", "Feature currenty unavalable");

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
            PromoCard(
              title: 'GET 10% OFF',
              subtitle: 'Order now with ideal online to get 10%off any order!',
              buttonText: 'Order now',
              imagePath: "assets/vegetables.jpeg", // Optional
              onTap: () {

              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
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
                      selectedColor: secondaryColor,
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Digital Aisles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Product Grid
            ProductGrid(
              products: filteredProducts,
              onAddToCart: (product) {
                cartController.addToCart(product);
                Get.snackbar(
                  "${product['name']} Added!",
                  "(${cartController.cartItems[product['name']]!['quantity']} in cart)",
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 1),
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
