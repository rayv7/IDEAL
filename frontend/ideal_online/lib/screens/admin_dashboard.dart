import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/controllers/catalog_controller.dart';
import 'package:ideal_online/configs/colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CatalogController catalogController = Get.put(CatalogController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    final categoryController = TextEditingController();
    Get.defaultDialog(
      title: 'Add New Category',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: categoryController,
          decoration: const InputDecoration(
            hintText: 'e.g., Household, Beverages',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      textConfirm: 'Add',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: primaryColor,
      onConfirm: () {
        if (categoryController.text.trim().isNotEmpty) {
          catalogController.addCategory(categoryController.text.trim());
          Get.back();
          Get.snackbar('Success', 'Category added successfully',
              snackPosition: SnackPosition.BOTTOM);
        }
      },
    );
  }

  void _showAddProductModal(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imagePathController = TextEditingController();
    String selectedCategory = catalogController.categories.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add New Product',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price (Ksh)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: catalogController.categories
                          .map((cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: imagePathController,
                      decoration: const InputDecoration(
                        labelText: 'Image Asset Path (Optional)',
                        hintText: 'assets/placeholder.png',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          final name = nameController.text.trim();
                          final price = double.tryParse(priceController.text) ?? 0.0;
                          final image = imagePathController.text.trim().isEmpty
                              ? 'assets/placeholder.png'
                              : imagePathController.text.trim();

                          if (name.isNotEmpty && price > 0) {
                            final newProduct = Product(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: name,
                              category: selectedCategory,
                              price: price,
                              imagePath: image,
                            );

                            catalogController.addProduct(newProduct);
                            Get.back();
                            Get.snackbar('Success', '$name added to inventory',
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar('Error', 'Please provide valid details',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white);
                          }
                        },
                        child: const Text(
                          'Save Product',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Portal'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_outlined),
            tooltip: 'Add Category',
            onPressed: _showAddCategoryDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.offAllNamed('/login'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2_outlined), text: 'Inventory'),
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Orders'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductModal(context),
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white)),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInventoryTab(),
          _buildOrdersTab(),
        ],
      ),
    );
  }

  Widget _buildInventoryTab() {
    return Obx(() {
      final products = catalogController.products;
      if (products.isEmpty) {
        return const Center(child: Text('No products available.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return Card(
            elevation: 1.5,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
              ),
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${item.category} • Ksh ${item.price.toStringAsFixed(0)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: () => _showEditPriceDialog(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      catalogController.removeProduct(item.id);
                      Get.snackbar('Deleted', '${item.name} removed from inventory');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  void _showEditPriceDialog(Product product) {
    final priceController =
        TextEditingController(text: product.price.toStringAsFixed(0));

    Get.defaultDialog(
      title: 'Update Price',
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'New Price for ${product.name}',
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      textConfirm: 'Update',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: primaryColor,
      onConfirm: () {
        final newPrice = double.tryParse(priceController.text);
        if (newPrice != null && newPrice > 0) {
          catalogController.updateProductPrice(product.id, newPrice);
          Get.back();
          Get.snackbar('Updated', 'Price updated successfully');
        }
      },
    );
  }

  Widget _buildOrdersTab() {
    // Sample mockup orders list for management
    final orders = [
      {
        'id': 'ORD-1002',
        'customer': 'John Doe',
        'items': '2x Superloaf Butter Toast, 1x Fresh Milk 1L',
        'total': 'Ksh 195',
        'status': 'Pending Payment'
      },
      {
        'id': 'ORD-1001',
        'customer': 'Raymond Athanas',
        'items': '1x CocaCola 2L, 1x Pembe Maize Flour',
        'total': 'Ksh 360',
        'status': 'Processing'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['id']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Chip(
                      label: Text(
                        order['status']!,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      backgroundColor: order['status'] == 'Processing'
                          ? Colors.orange
                          : Colors.blue,
                    )
                  ],
                ),
                Text('Customer: ${order['customer']}',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text('Items: ${order['items']}'),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${order['total']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 15),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                      onPressed: () {
                        Get.snackbar('Order Updated',
                            'Marked ${order['id']} as Completed');
                      },
                      child: const Text('Complete Order',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}