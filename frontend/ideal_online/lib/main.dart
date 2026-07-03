import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: IdealMinimartHome(),
  ));
}

class IdealMinimartHome extends StatelessWidget {
  const IdealMinimartHome({super.key});

  @override
  Widget  build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Layer 1:
          ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 80),

              Container(
                height: 300,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Promo Carousele Placeholder',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 221, 0, 0),
                  ),
                ), 
              ),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'PlaceHolder for Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 3, 136, 20)),
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