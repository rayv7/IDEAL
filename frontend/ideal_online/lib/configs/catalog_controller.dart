class CatalogController {
  final List<String> categories = [
    'Dairy',
    'Bakery',
    'Flour'
    'Home Care',
    'Sweet & Platters',
    'Nursery',
    'Snacks',
    'Beverages',
  ];

  final List<Map<String, String>> _allProducts = [
    {'name': 'Superloaf Butter Toast', 'category': 'Bakery', 'price': 'Ksh 65', 'image': 'assets/Bread_supaloaf_butterToast.png'},
    {'name': 'Brookside Dairy Best', 'category': 'Dairy', 'price': '60', 'image': 'assets/Brookside_DairyBest_500ml.png'},
    {'name': 'Daima Whole Milk', 'category': 'Dairy', 'price': 'Khs 70', 'image': 'assets/Daima_WholeMilk_500ml.png'},
    {'name': 'Pembe Maize Flour', 'category': 'Flour', 'price': 'Ksh 160', 'image': 'assets/Flour_PembeMaizeFlour.png'},
    {'name': 'Raha Premium Maize Flour', 'category': 'Flour', 'price': 'Ksh 170', 'image': ''},
    {'name': '', 'category': '', 'price': '', 'image': ''},
    {'name': '', 'category': '', 'price': '', 'image': ''},
    {'name': '', 'category': '', 'price': '', 'image': ''},
    {'name': '', 'category': '', 'price': '', 'image': ''},
    {'name': 'Festive Bread Mlky White', 'category': 'Bakery', 'price': 'Ksh 65', 'image': 'assets/Bread_Festive_MilkyWhite.png'},
    {'name': 'CocaCola 2L', 'category': 'Beverages', 'price': 'Ksh 200', 'image': 'assets/Soda_Cocacola_2L.jpg'},
    {'name': 'Fresh Milk 1L', 'category': 'Dairy', 'price': 'KSh 65', 'image': 'assets/Brookside_DairyBest_500ml.png'},
    {'name': 'Yogurt 250g', 'category': 'Dairy', 'price': 'KSh 40', 'image': 'assets/Yorghurt_Delamere_PinappleandCoconut.png'},
    {'name': 'Premium Bread 400g', 'category': 'Sweet & Platters', 'price': 'KSh 60'},
    {'name': 'Dishwashing Liquid', 'category': 'Home Care', 'price': 'KSh 120'},
    {'name': 'Baby Wipes', 'category': 'Nursery', 'price': 'KSh 150'},
    {'name': 'Potato Crisps', 'category': 'Snacks', 'price': 'KSh 50'},
  ];

  // Helper function to return only products belonging to the selected category
  List<Map<String, String>> getFilteredProducts(String selectedCategory) {
    return _allProducts
        .where((product) => product['category'] == selectedCategory)
        .toList();
  }
}