import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ideal_online/configs/routes.dart';

void main() {
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
      debugShowCheckedModeBanner: false,
      title: 'IDEAL MINIMART',
      initialRoute: "/",
      getPages: routes,
    );
  }
}