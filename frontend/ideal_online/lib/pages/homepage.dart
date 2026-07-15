import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'dart:ui';
import 'dart:async';
import '../catalog_controller.dart';

void main() {
  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: IdealMinimartHome(),
  ));
}

class IdealMinimartHome extends StatefulWidget {
  const IdealMinimartHome({super.key});

  

  @override
  State<IdealMinimartHome> createState() => _IdealMinimartHomeState();
}

class _IdealMinimartHomeState extends State<IdealMinimartHome> {
  late final PageController _pageController;
  late final Timer _carouselTimer;
  int _currentPage = 0;

  final CatalogController _catalogController = CatalogController();
  String selectedCategory = 'Dairy'; // Default selected category

  final List<String> promoItems = [
    'Order now and get 10% off!',
    'Free delivery for orders above Ksh50!',
    'Visit our food court for exclusive deals!',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < promoItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _carouselTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Layer 1:
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 80),

              SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: promoItems.length,
                  onPageChanged: (index) {
                    _currentPage = index;
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        promoItems[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 3, 136, 20)),
                ),
              ),
                
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _catalogController.categories.length,
                  itemBuilder: (context, index) {
                    final categoryName = _catalogController.categories[index];
                    final isSelected = categoryName == selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categoryName;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.green : const Color(0xFFE0E0E0),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Icon(
                                Icons.shopping_basket_outlined,
                                color: isSelected ? Colors.green : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              categoryName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.green : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // 1. Digital Aisles Section Header Title
              const Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  right: 16,
                  left: 24,
                  bottom: 4,
                ),
                child: Text(
                  'Digital Aisles',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // 2. Product Items 2-Column Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Builder(
                  builder: (context) {
                    final filteredProducts = _catalogController.getFilteredProducts(selectedCategory);

                    if (filteredProducts.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text('No products found in this category.'),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFEEEEEE)),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: product['image'] != null
                                      ? Image.asset(
                                        product['image']!,
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(Icons.image, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                product['name'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product['price'] ?? '',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
          // Layer 2:
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: 60 + MediaQuery.of(context).padding.top,
                  color: Colors.white.withValues(alpha: 0.7),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    right: 20,
                    left: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'IDEAL Minimart',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B5E20),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Order via whatsapp',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
}}