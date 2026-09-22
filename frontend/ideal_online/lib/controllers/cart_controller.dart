import 'package:get/get.dart';

class CartController extends GetxController {
  // Reactive map storing cart items
  // Format: { 'Product Name': { 'product': Map<String, String>, 'quantity': int } }
  var cartItems = <String, Map<String, dynamic>>{}.obs;

  // Add item or increment quantity if already added
  void addToCart(Map<String, String> product) {
    final name = product['name'] ?? '';
    if (name.isEmpty) return;

    if (cartItems.containsKey(name)) {
      cartItems[name]!['quantity'] += 1;
    } else {
      cartItems[name] = {
        'product': product,
        'quantity': 1,
      };
    }
    cartItems.refresh(); // Triggers UI updates across all Obx listeners
  }

  // Decrement item quantity or remove completely if quantity hits 0
  void removeFromCart(String name) {
    if (!cartItems.containsKey(name)) return;

    if (cartItems[name]!['quantity'] > 1) {
      cartItems[name]!['quantity'] -= 1;
    } else {
      cartItems.remove(name);
    }
    cartItems.refresh();
  }

  // Calculate total count of all individual items in cart
  int get totalItemCount {
    int total = 0;
    cartItems.forEach((key, value) {
      total += (value['quantity'] as int);
    });
    return total;
  }

  // Calculate overall subtotal price
  double get subtotal {
    double total = 0.0;
    cartItems.forEach((key, value) {
      final product = value['product'] as Map<String, String>;
      final quantity = value['quantity'] as int;
      
      // Clean price string (e.g., "Ksh 65" or "65.0" -> 65.0)
      final priceString = product['price']?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0';
      final price = double.tryParse(priceString) ?? 0.0;
      
      total += (price * quantity);
    });
    return total;
  }
}