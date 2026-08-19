import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:ideal_online/screens/cart.dart';
import 'package:ideal_online/screens/categories.dart';
import 'package:ideal_online/screens/homepage.dart';
import 'package:ideal_online/screens/login_screen.dart';
import 'package:ideal_online/screens/profile_page.dart';
import 'package:ideal_online/screens/registration_screen.dart';

var routes = [
  GetPage(name: "/", page: () => LoginScreen()),
  GetPage(name: "/registration", page: () => RegistrationScreen()),
  GetPage(name: "/home", page: () => IdealMinimartHome()),
  GetPage(name: "/profile", page: () => ProfilePage()),
  GetPage(name: "/categories", page: () => Categories()),
  GetPage(name: "/cart", page: () => cart()),
];