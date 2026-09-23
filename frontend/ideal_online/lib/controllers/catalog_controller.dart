import 'package:get/get.dart';

class Product {
  final String id;
  String name;
  String category;
  double price;
  String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
  });

  // Helper to convert to Map representation if needed elsewhere
  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': 'Ksh ${price.toStringAsFixed(0)}',
      'image': imagePath,
    };
  }
}

class CatalogController extends GetxController {
  var categories = <String>[
    'Dairy',
    'Bakery',
    'Flour',
    'Home Care',
    'Sweet & Platters',
    'Nursery',
    'Snacks',
    'Beverages',
  ].obs;

  var products = <Product>[
    Product(
      id: '1',
      name: 'Superloaf Butter Toast',
      category: 'Bakery',
      price: 65.0,
      imagePath: 'assets/Bread_supaloaf_butterToast.png',
    ),
    Product(
      id: '2',
      name: 'Brookside Dairy Best',
      category: 'Dairy',
      price: 60.0,
      imagePath: 'assets/Brookside_DairyBest_500ml.png',
    ),
    Product(
      id: '3',
      name: 'Daima Whole Milk',
      category: 'Dairy',
      price: 70.0,
      imagePath: 'assets/Daima_WholeMilk_500ml.png',
    ),
    Product(
      id: '4',
      name: 'Pembe Maize Flour',
      category: 'Flour',
      price: 160.0,
      imagePath: 'assets/Flour_PembeMaizeFlour.png',
    ),
    Product(
      id: '5',
      name: 'Raha Premium Maize Flour',
      category: 'Flour',
      price: 170.0,
      imagePath: 'assets/placeholder.png',
    ),
    Product(
      id: '6',
      name: 'Festive Bread Mlky White',
      category: 'Bakery',
      price: 65.0,
      imagePath: 'assets/Bread_Festive_MilkyWhite.png',
    ),
    Product(
      id: '7',
      name: 'CocaCola 2L',
      category: 'Beverages',
      price: 200.0,
      imagePath: 'assets/Soda_Cocacola_2L.jpg',
    ),
    Product(
      id: '8',
      name: 'Fresh Milk 1L',
      category: 'Dairy',
      price: 65.0,
      imagePath: 'assets/Brookside_DairyBest_500ml.png',
    ),
    Product(
      id: '9',
      name: 'Yogurt 250g',
      category: 'Dairy',
      price: 40.0,
      imagePath: 'assets/Yorghurt_Delamere_PinappleandCoconut.png',
    ),
    Product(
      id: '10',
      name: 'Premium Bread 400g',
      category: 'Sweet & Platters',
      price: 60.0,
      imagePath: 'assets/placeholder.png',
    ),
    Product(
      id: '11',
      name: 'Dishwashing Liquid',
      category: 'Home Care',
      price: 120.0,
      imagePath: 'assets/placeholder.png',
    ),
    Product(
      id: '12',
      name: 'Baby Wipes',
      category: 'Nursery',
      price: 150.0,
      imagePath: 'assets/placeholder.png',
    ),
    Product(
      id: '13',
      name: 'Potato Crisps',
      category: 'Snacks',
      price: 50.0,
      imagePath: 'assets/placeholder.png',
    ),
  ].obs;

  List<Product> getFilteredProducts(String selectedCategory) {
    if (selectedCategory.isEmpty) return products;
    return products
        .where((product) => product.category == selectedCategory)
        .toList();
  }

  void addCategory(String categoryName) {
    final trimmed = categoryName.trim();
    if (trimmed.isNotEmpty && !categories.contains(trimmed)) {
      categories.add(trimmed);
    }
  }

  void addProduct(Product product) {
    products.add(product);
    if (!categories.contains(product.category)) {
      categories.add(product.category);
    }
  }

  void removeProduct(String productId) {
    products.removeWhere((p) => p.id == productId);
  }

  void updateProductPrice(String productId, double newPrice) {
    final index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      products[index].price = newPrice;
      products.refresh();
    }
  }
}