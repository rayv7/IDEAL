import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/widgets/bottom_nav_bar.dart';
import 'package:ideal_online/widgets/nav_bar.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. User Header Section
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Raymond Athanas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'raymondathanas@gmail.com',
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
              onTap: () {
                // Navigate to orders
              },
            ),
            _ProfileTile(
              icon: Icons.favorite_outline,
              title: 'Wishlist',
              onTap: () {

              },
            ),
            _ProfileTile(
              icon: Icons.location_on_outlined,
              title: 'Shipping Addresses',
              onTap: () {
                
              },
            ),
            _ProfileTile(
              icon: Icons.payment_outlined,
              title: 'Payment Methods',
              onTap: () {
                
              },
            ),
            _ProfileTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
           
              },
            ),
            _ProfileTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
       
              },
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