import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/controllers/cart_controller.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/checkout_sheet.dart';
import 'package:ideal_online/widgets/nav_bar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  final double _deliveryFee = 50.0;

  @override
  Widget build(BuildContext context) {
    // Find the global instance of CartController
    final CartController cartController = Get.find<CartController>();

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
      // Obx listens to reactive changes in CartController
      body: Obx(() {
        final itemsList = cartController.cartItems.values.toList();

        if (itemsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Cart is Empty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Looks like you haven\'t added anything yet.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/home");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Start Shopping'),
                ),
              ],
            ),
          );
        }

        // Calculate subtotal directly from reactive items list
        final double subtotal = itemsList.fold(0.0, (sum, entry) {
          final product = entry['product'] as Map<String, String>;
          final quantity = entry['quantity'] as int;
          // Clean price string (e.g. "Ksh 65" -> 65.0)
          final priceString = product['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0';
          final price = double.tryParse(priceString) ?? 0.0;
          return sum + (price * quantity);
        });

        return Column(
          children: [
            // 1. Cart Items List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: itemsList.length,
                itemBuilder: (context, index) {
                  final entry = itemsList[index];
                  final product = entry['product'] as Map<String, String>;
                  final quantity = entry['quantity'] as int;
                  final name = product['name'] ?? '';

                  return Dismissible(
                    key: Key(name),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (_) {
                      cartController.cartItems.remove(name);
                      cartController.cartItems.refresh();
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Item Thumbnail Image
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: product['image'] != null &&
                                      product['image']!.isNotEmpty
                                  ? Image.asset(
                                      product['image']!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stack) =>
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
                            const SizedBox(width: 12),

                            // Title & Price Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                            ),

                            // Quantity Adjuster (- quantity +)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    onPressed: () {
                                      if (quantity > 1) {
                                        cartController.cartItems[name]!['quantity'] -= 1;
                                        cartController.cartItems.refresh();
                                      } else {
                                        cartController.cartItems.remove(name);
                                        cartController.cartItems.refresh();
                                      }
                                    },
                                  ),
                                  Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 18),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    onPressed: () {
                                      cartController.addToCart(product);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 2. Order Summary Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    label: 'Subtotal',
                    value: 'Ksh ${subtotal.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    label: 'Delivery Fee',
                    value: 'Ksh ${_deliveryFee.toStringAsFixed(0)}',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(),
                  ),
                  _SummaryRow(
                    label: 'Total',
                    value: 'Ksh ${(subtotal + _deliveryFee).toStringAsFixed(0)}',
                    isTotal: true,
                  ),
                  const SizedBox(height: 16),

                  // Checkout CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent, // Required for clean rounded corners
                          barrierColor: Colors.black.withOpacity(0.5), // Blurs/darkens background
                          builder: (context) {
                            return CheckoutSheet(
                              cartItems: cartController.cartItems,
                              subtotal: subtotal,
                              deliveryFee: _deliveryFee,
                            );
                          },
                        );
                        // Proceed to Checkout / Daraja M-Pesa logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: IdealBottomNavBar(
        currentIndex: 3,
        onTap: (_) {},
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}