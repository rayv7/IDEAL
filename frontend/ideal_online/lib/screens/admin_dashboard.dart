import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ideal_online/controllers/catalog_controller.dart';
import 'package:ideal_online/configs/colors.dart';
import 'package:http/http.dart' as http;

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
      onConfirm: () async {
        final categoryName = categoryController.text.trim();
        if (categoryName.isNotEmpty) {
          try {
            var response = await http.post(
              Uri.parse('http://10.0.2.2/backend/add_category.php'),
              body: {'name': categoryName},
            );

            var body = jsonDecode(response.body);

            if (body['success'] == 1) {
              Get.back();
              Get.snackbar(
                'Success',
                'Category "$categoryName" saved to database',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
              await catalogController.fetchCategoriesFromBackend();
            } else {
              Get.snackbar(
                'Error',
                body['message'] ?? 'Failed to add category',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          } catch (e) {
            Get.snackbar(
              'Error',
              'Could not connect to backend server',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        }
      },
    );
  }

  void _showAddProductModal(BuildContext context) {
    // Ensure we have fresh categories from backend when opening modal
    catalogController.fetchCategoriesFromBackend();

    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final unitAmountController = TextEditingController();
    final imagePathController = TextEditingController();

    String selectedUnitType = 'Litres (L)';
    String? selectedCategoryId;
    File? pickedImageFile;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> pickImage() async {
              final picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                setModalState(() {
                  pickedImageFile = File(image.path);
                  imagePathController.text = image.path;
                });
              }
            }

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

                    // Unit Amount and Type
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: unitAmountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Amount (e.g. 1, 500)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: selectedUnitType,
                            decoration: const InputDecoration(
                              labelText: 'Unit Type',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              'Litres (L)',
                              'Millilitres (ml)',
                              'Kilograms (Kg)',
                              'Grams (g)',
                              'Packs',
                              'Pieces'
                            ]
                                .map((unit) => DropdownMenuItem(
                                      value: unit,
                                      child: Text(unit),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => selectedUnitType = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dynamic Category Selection
                    Obx(() {
                      final categoriesList = catalogController.categories;
                      if (categoriesList.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'No categories found in database. Tap + above to add one.',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      // Ensure selectedCategoryId matches a valid ID in the list
                      if (selectedCategoryId == null ||
                          !categoriesList.any((c) => c.id == selectedCategoryId)) {
                        selectedCategoryId = categoriesList.first.id;
                      }

                      return DropdownButtonFormField<String>(
                        value: selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: categoriesList
                            .map((cat) => DropdownMenuItem(
                                  value: cat.id,
                                  child: Text(cat.name),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedCategoryId = val);
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 12),

                    // Image Picker Section
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: pickedImageFile != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    pickedImageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.image, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: pickImage,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Pick Image from Gallery'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: imagePathController,
                      decoration: const InputDecoration(
                        labelText: 'Or Paste Image URL / Asset Path',
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
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final price = priceController.text.trim();
                          final unitAmount = unitAmountController.text.trim();
                          final unitLabel = selectedUnitType
                              .split(' ')
                              .last
                              .replaceAll('(', '')
                              .replaceAll(')', '');
                          final fullUnit = unitAmount.isNotEmpty
                              ? '$unitAmount $unitLabel'
                              : unitLabel;

                          if (name.isNotEmpty &&
                              price.isNotEmpty &&
                              selectedCategoryId != null) {
                            try {
                              var request = http.MultipartRequest(
                                'POST',
                                Uri.parse('http://10.0.2.2/backend/add_product.php'),
                              );

                              request.fields['name'] = name;
                              request.fields['price'] = price;
                              request.fields['category_id'] = selectedCategoryId!;
                              request.fields['unit'] = fullUnit;
                              request.fields['quantity'] = '50';
                              request.fields['description'] = 'Product description';

                              if (pickedImageFile != null) {
                                request.files.add(
                                  await http.MultipartFile.fromPath(
                                      'image', pickedImageFile!.path),
                                );
                              } else if (imagePathController.text.isNotEmpty) {
                                request.fields['image_url'] =
                                    imagePathController.text.trim();
                              }

                              var streamedResponse = await request.send();
                              var response =
                                  await http.Response.fromStream(streamedResponse);

                              if (response.statusCode == 200) {
                                Get.back();
                                await catalogController.fetchProductsFromBackend();

                                Get.snackbar(
                                  'Success',
                                  '$name saved to database successfully',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  'Error',
                                  'Server status code: ${response.statusCode}',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                              }
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Could not connect to backend server',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                              );
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill in product name, price, and select a category',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
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
      if (catalogController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final products = catalogController.products;
      if (products.isEmpty) {
        return const Center(child: Text('No products available in database.'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];

          Widget leadingImage;
          if (item.imagePath.startsWith('http')) {
            leadingImage = Image.network(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            );
          } else if (File(item.imagePath).existsSync()) {
            leadingImage = Image.file(
              File(item.imagePath),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            );
          } else {
            leadingImage = Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.image),
            );
          }

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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: leadingImage,
                ),
              ),
              title: Text(item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  '${item.category} • ${item.unit} • Ksh ${item.price.toStringAsFixed(0)}'),
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
                      Get.snackbar(
                          'Deleted', '${item.name} removed from inventory');
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
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white),
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor),
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