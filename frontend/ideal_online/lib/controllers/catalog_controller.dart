import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CategoryItem {
  final String id;
  final String name;

  CategoryItem({required this.id, required this.name});

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: (json['category_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }
}

class Product {
  final String id;
  String name;
  String category;
  double price;
  String imagePath;
  String unit;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    this.unit = '',
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? 'General',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imagePath: json['imagePath'] ?? 'assets/placeholder.png',
      unit: json['unit'] ?? '',
    );
  }

  // Converts Product instance to Map expected by ProductGrid and Cart
  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': 'Ksh ${price.toStringAsFixed(0)}',
      'image': imagePath,
      'unit': unit,
    };
  }
}

class CatalogController extends GetxController {
  var isLoading = false.obs;
  var categories = <CategoryItem>[].obs;
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategoriesFromBackend();
    fetchProductsFromBackend();
  }

  Future<void> fetchProductsFromBackend() async {
    try {
      isLoading.value = true;
      var response = await http.get(
        Uri.parse("https://ideal-minimart.wuaze.com/get_products.php"),
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body['success'] == 1) {
          List<dynamic> data = body['data'];
          products.value = data.map((item) => Product.fromJson(item)).toList();
        }
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoriesFromBackend() async {
    try {
      var response = await http.get(
        Uri.parse("https://ideal-minimart.wuaze.com/get_categories.php"),
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        if (body['success'] == 1) {
          List<dynamic> data = body['data'];
          categories.value =
              data.map((item) => CategoryItem.fromJson(item)).toList();
        }
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  List<Product> getFilteredProducts(String categoryName) {
    if (categoryName.isEmpty || categoryName == 'All') return products;
    return products.where((product) => product.category == categoryName).toList();
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