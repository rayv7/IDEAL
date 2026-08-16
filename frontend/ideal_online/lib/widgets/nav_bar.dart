import 'package:flutter/material.dart';
import 'package:ideal_online/configs/colors.dart';

class IdealAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoPath;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchSubmitted;
  final List<Widget>? actions;

  const IdealAppBar({
    super.key,
    required this.logoPath,
    this.searchController,
    this.onSearchSubmitted,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: secondaryColor.withOpacity(0.9),
      centerTitle: true,
      titleSpacing: 8,
      leadingWidth: 100,

      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Image.asset(
          logoPath,
          fit: BoxFit.contain,
        ),
      ),
      title: SizedBox(
        height: 40,
        child: TextField(
          controller: searchController,
          onSubmitted: onSearchSubmitted,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
            prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actions: actions ?? [],
    );
  }
}   