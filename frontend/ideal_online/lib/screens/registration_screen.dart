import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../configs/colors.dart';
import '../configs/styles.dart';

bool registering = false;

TextEditingController firstNameController = TextEditingController();
TextEditingController secondNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneNumberController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register - IDEAL MINIMART',
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
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Card(
                  elevation: 18, // Elevation creates the floating depth effect
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
                            Flexible(child: Image.asset("assets/logo_nbg.png")),
                          ],
                        ),
                        Text(
                          "First name",
                          style: subHeader,
                        ),
                        TextField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Second name",
                          style: subHeader,
                        ),
                        TextField(
                          controller: secondNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "email",
                          style: subHeader,
                        ),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Phone number",
                          style: subHeader,
                        ),
                        TextField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Password",
                          style: subHeader,
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Confirm password",
                          style: subHeader,
                        ),
                        TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: 50,
                              minWidth: 200,
                              onPressed: () async {
                                if (passwordController.text != confirmPasswordController.text) {
                                  Get.snackbar("Error", "Passwords do not match.");
                                  return;
                                } else if (firstNameController.text.isEmpty ||
                                    secondNameController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    phoneNumberController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                    Get.snackbar("Error", "Please fill in all fields.");
                                  return;
                                } else {
                                  setState(() {
                                    registering = true;
                                  });
                                  try {
                                    var response = await http.post(
                                      Uri.parse("http://10.0.2.2/backend/create.php"),
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
                                      Get.snackbar("Success", "Registration successful, Welcome to IDEAL MINIMART ${firstNameController.text}");
                                      Get.toNamed("/login");
                                    } else {
                                      Get.snackbar("Error", "Registration failed, please try again.");
                                    }
                                  } catch (e) {
                                    Get.snackbar("Connection Error", "Could not connect to server: $e");
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
                                ? CircularProgressIndicator()
                                : Text(
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
                        SizedBox(height: 20),
                      ],
                    )
                  ),
                ),
            ),
          ),
        ),
      ]
      ),
    );
  }
}
