import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ideal_online/configs/colors.dart';
import 'package:ideal_online/controllers/cart_controller.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/nav_bar.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? userEmail;
  String? userPhone;

  @override
  void initState() {
    super.initState();
    load();
  }

  void _showLoadError(String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Get.snackbar("Error", message);
      }
    });
  }

  Future<void> load() async {
    try {
      final box = GetStorage();
      final phone = box.read('phonenum') ?? box.read('username');

      if (phone == null || phone.toString().isEmpty) {
        _showLoadError("No logged in user found");
        return;
      }

      var response = await http.get(
        Uri.https(
          'ideal-minimart.wuaze.com',
          '/get_user.php',
          {'phonenum': phone.toString()},
        ),
        headers: {'ngrok-skip-browser-warning': 'true'},
      );

      var serverResponse = jsonDecode(response.body);
      if (serverResponse['success'] == 1) {
        final user = serverResponse['data'][0];
        if (!mounted) return;
        setState(() {
          userName = '${user['fname']} ${user['sname']}';
          userEmail = user['email'];
          userPhone = user['phonenum'];
        });
      } else {
        _showLoadError(
          serverResponse['message'] ?? "Could not fetch user data",
        );
      }
    } catch (e) {
      debugPrint('Profile load error: $e');
      _showLoadError("Could not connect to backend server");
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Scaffold(
      appBar: IdealAppBar(
        logoPath: 'assets/logo_nbg.png',
        onSearchSubmitted: (query) {
          Get.snackbar("Coming soon!!!", "Feature currently unavailable");
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
        ],
      ),
      body: RefreshIndicator(
        color: primaryColor,
        onRefresh: () async {
          await load();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor:
                          Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userName ?? 'Loading...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail ?? 'Loading...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userPhone ?? 'Loading...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(height: 1),
              _ProfileTile(
                icon: Icons.shopping_bag_outlined,
                title: 'My Orders',
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.favorite_outline,
                title: 'Wishlist',
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.location_on_outlined,
                title: 'Shipping Addresses',
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {},
              ),
              _ProfileTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _ProfileTile(
                icon: Icons.logout,
                title: 'Logout',
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () {
                  Get.toNamed("/login");
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: IdealBottomNavBar(
        currentIndex: 4,
        onTap: (_) {},
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}