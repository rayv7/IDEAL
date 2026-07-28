import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ideal_online/configs/colors.dart';

TextEditingController usernameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
var store = GetStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    usernameController.text = store.read("username") ?? "";
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'IDEAL MINIMART',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Times New Roman',
            ),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // Handle exit button press
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
                    child: SvgPicture.asset("assets/Ideal_logo.svg"),
                  ),
                ],
              ),
              Text(
                "Username",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: secondaryColor,
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: secondaryColor),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: secondaryColor,
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: secondaryColor),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    height: 50,
                    minWidth: 200,
                    onPressed: () {
                      store.write("username", usernameController.text);
                      Get.toNamed("/home");
                    },
                    color: buttonColor,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Text(
                      "Not registered? Sign up.",
                      style: TextStyle(
                        color: linkColor,
                        fontSize: 12,
                      ),
                    ),
                    onTap: () {
                      Get.toNamed("/registration");
                    }
                  ),
                  Spacer(),
                  Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: linkColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}