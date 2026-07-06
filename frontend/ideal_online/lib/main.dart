import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';

void main() {
  runApp(const MaterialApp(
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

  final List<String> promoItems = [
    'Order now and get 10% off!',
    'Free delivery for orders above Ksh50!',
    'Visit our food court for exclusive deals!',
  ];

  final List<String> categories = [
    'Fruits & Vegetables',
    'Dairy Products',
    'Beverages',
    'Snacks',
    'Hot dog stand',
    'Personal Care',
    'Household essentials',
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
                    'PlaceHolder for Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 3, 136, 20)),
                  ),
                ),
                
              SizedBox (
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_basket_outlined,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            categories[index],
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                        ),
                    );
                  }
                ),
              ),
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
                  height: 80,
                  color: Colors.white.withValues(alpha: 0.7),
                  padding:const EdgeInsets.symmetric(horizontal: 20),
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
  }
}