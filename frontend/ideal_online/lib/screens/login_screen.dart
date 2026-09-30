import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ideal_online/configs/colors.dart';
import '../configs/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GetStorage store = GetStorage();

  // SPECIAL ADMIN CREDENTIALS
  static const String adminUsername = "admin";
  static const String adminPassword = "Admin123Pass!";

  @override
  void initState() {
    super.initState();
    usernameController.text = store.read("username") ?? "";
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg_poster.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 18,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                child: Image.asset("assets/logo_nbg.png"),
                              ),
                            ],
                          ),
                          Text(
                            "Username (Phone Number)",
                            style: subHeader,
                          ),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon:
                                  Icon(Icons.person, color: secondaryColor),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Password",
                            style: subHeader,
                          ),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              prefixIcon:
                                  Icon(Icons.lock, color: secondaryColor),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterialButton(
                                height: 50,
                                minWidth: 200,
                                onPressed: () async {
                                  final username = usernameController.text.trim();
                                  final password = passwordController.text.trim();

                                  if (username.isEmpty || password.isEmpty) {
                                    Get.snackbar(
                                      "Error",
                                      "Please enter both username and password",
                                    );
                                    return;
                                  }

                                  // 1. CHECK FOR ADMIN CREDENTIALS FIRST
                                  if (username == adminUsername &&
                                      password == adminPassword) {
                                    store.write("is_admin", true);
                                    store.write("username", username);

                                    Get.snackbar(
                                      "Admin Portal",
                                      "Welcome back, Admin!",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );

                                    Get.toNamed("/admin");
                                    return;
                                  }

                                  // 2. STANDARD CUSTOMER LOGIN VIA PHP BACKEND
                                  try {
                                    var response = await http.get(
                                      Uri.parse(
                                        "http://10.0.2.2/backend/login.php?phonenum=$username&password=$password",
                                      ),
                                    );

                                    var responseBody =
                                        jsonDecode(response.body);
                                    int loggedIn = responseBody['success'];

                                    if (loggedIn == 1) {
                                      store.write("is_admin", false);
                                      store.write("username", username);
                                      store.write(
                                        "userID",
                                        responseBody['data'][0]['id'],
                                      );
                                      store.write(
                                        "firstname",
                                        responseBody['data'][0]['fname'],
                                      );
                                      Get.toNamed("/home");
                                      Get.snackbar(
                                        "Success",
                                        "Logged in successfully",
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "Invalid username or password",
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error",
                                      "Could not connect to backend server",
                                    );
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                color: buttonColor,
                                child: const Text(
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
                          const SizedBox(height: 20),
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
                                },
                              ),
                              const Spacer(),
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}