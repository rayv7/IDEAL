import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ideal_online/configs/colors.dart';
import 'package:http/http.dart' as http;
import 'package:ideal_online/widgets/nav_bar.dart';

import '../configs/styles.dart';

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
                            "Username (Phone Number)",
                            style: subHeader,
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
                            style: subHeader,
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
                                onPressed: () async {
                                  var response = await http.get(
                                    Uri.parse(
                                      "http://10.0.2.2/backend/login.php?phonenum=${usernameController.text}&password=${passwordController.text}",
                                    ),
                                  );
                              
                                  var responseBody = jsonDecode(response.body);
                              
                                  int loggedIn = responseBody['success'];
                              
                                  if (loggedIn == 1) {
                                    store.write("username", usernameController.text);
                                    store.write("userID", responseBody['data'][0]['id']);
                                    store.write(
                                      "firstname",
                                      responseBody['data'][0]['fname'],
                                    );
                                    Get.toNamed("/home");
                                  } else {
                                    Get.snackbar("Error", "Invalid username or password");
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
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
                                  style: TextStyle(color: linkColor, fontSize: 12),
                                ),
                                onTap: () {
                                  Get.toNamed("/registration");
                                },
                              ),
                              Spacer(),
                              Text(
                                "Forgot password?",
                                style: TextStyle(color: linkColor, fontSize: 12),
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
      )
    );
  }
}
