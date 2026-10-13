import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../configs/colors.dart';
import '../configs/styles.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool registering = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register - IDEAL MINIMART',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
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
                physics: const AlwaysScrollableScrollPhysics(),
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
                                child: Image.asset("assets/logo_nbg.png")),
                          ],
                        ),
                        Text("First name", style: subHeader),
                        TextField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Second name", style: subHeader),
                        TextField(
                          controller: secondNameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Email", style: subHeader),
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Phone number", style: subHeader),
                        TextField(
                          controller: phoneNumberController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text("Password", style: subHeader),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 16),
                        Text("Confirm password", style: subHeader),
                        TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: 50,
                              minWidth: 200,
                              onPressed: () async {
                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  Get.snackbar(
                                      "Error", "Passwords do not match.");
                                  return;
                                } else if (firstNameController.text.isEmpty ||
                                    secondNameController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    phoneNumberController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  Get.snackbar(
                                      "Error", "Please fill in all fields.");
                                  return;
                                } else {
                                  setState(() {
                                    registering = true;
                                  });
                                  try {
                                    var response = await http.post(
                                      Uri.parse(
                                        "https://refract-strung-mama.ngrok-free.dev/backend/create.php"
                                      ),
                                      body: {
                                        "fname": firstNameController.text,
                                        "sname": secondNameController.text,
                                        "email": emailController.text,
                                        "phonenum": phoneNumberController.text,
                                        "password": passwordController.text,
                                      },
                                    );

                                    var serverResponse = jsonDecode(response.body);

                                    if (serverResponse['success'] == 1) {
                                      Get.snackbar("Success",
                                          "Welcome to IDEAL MINIMART ${firstNameController.text}");
                                      Get.toNamed("/login");
                                    } else {
                                      Get.snackbar("Error",
                                          "Registration failed, please try again.");
                                    }
                                  } catch (e) {
                                    Get.snackbar("Connection Error",
                                        "Could not connect to server: $e");
                                  } finally {
                                    setState(() {
                                      registering = false;
                                    });
                                  }
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: buttonColor,
                              child: registering
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      "Sign up",
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
                      ],
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