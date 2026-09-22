import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/configs/routes.dart';
import 'package:ideal_online/controllers/cart_controller.dart';



void main() {
  Get.put(CartController());
  
  runApp(IdealMinimart());
}

class IdealMinimart extends StatefulWidget {
  const IdealMinimart({super.key});

  @override
  State<IdealMinimart> createState() => _IdealMinimartState();
}

class _IdealMinimartState extends State<IdealMinimart> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green, 
          surface: Colors.white,  
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'IDEAL MINIMART',
      initialRoute: "/",
      getPages: routes,
    );
  }
}