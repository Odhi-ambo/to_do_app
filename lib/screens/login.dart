import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:to_do_app_fl/constants/server_url.dart';
import 'package:to_do_app_fl/controllers/userController.dart';
import 'package:to_do_app_fl/utils/sharedpreferences.dart';

bool showPass = false;
bool isLoading = false;

//shared preferences object
//we have two functions. read and write
MysharedPreferences myPref = MysharedPreferences();

//controllers to track inputs on text fields
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

//to access the state we initialize the constructor
UserDetailsController userDetailsController = Get.put(UserDetailsController());

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    //we can now read values from sharedpreferences
    //the key must be what you had when writing
    //since we are reading from the futre and not immediately we need .then
    myPref.getValue("email").then(
          (value) => {emailController.text = value},
        );

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                //background overlay
                // Container(
                //   height: double.infinity,
                //   color: Colors.black.withOpacity(0.9),
                // ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Kindly Login",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: "email",
                                      labelText: "Please Enter Email",
                                      labelStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: showPass ? false : true,
                                    decoration: InputDecoration(
                                      hintText: "password",
                                      labelText: "Enter Password",
                                      labelStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            showPass = !showPass;
                                          });
                                        },
                                        icon: Icon(showPass
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  isLoading
                                      ? Center(
                                          child: Column(
                                            children: [
                                              LoadingAnimationWidget
                                                  .newtonCradle(
                                                      color: Colors.black,
                                                      size: 50),
                                              const Text("Please Wait")
                                            ],
                                          ),
                                        )
                                      : ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty
                                                .all<Color>(Colors
                                                    .transparent), // Set your desired background color
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(double.infinity, 0)),
                                          ),
                                          onPressed: () {
                                            checkUserDetails();
                                          },
                                          child: const Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Login Now",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.login,
                                                  color: Colors.black,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed("/register");
                                      },
                                      child: const Text("No Account Yet"),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });
    var response = await loginUser();
    if (response.statusCode == 200) {
      // Parse the JSON response body
      var jsonResponse = jsonDecode(response.body);

      // Extract email and phone from the JSON response
      String fullname = jsonResponse['fullname'];
      String email = jsonResponse['email'];
      String userId = jsonResponse['id'].toString();
      String phone = jsonResponse['phone'].toString();
      String password = jsonResponse['password'].toString();

      userDetailsController.updateUserDetails(
        fullname,
        email,
        userId,
        phone,
        password,
      );

      //we are going to store username and phone locally in sharedPreferences
      myPref.writeValue("email", emailController.text);

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pushReplacementNamed("/main");
    } else {
      print('Failed to login user. Status code: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
      showingDialogMsg("Login Error", "Incorrect Username or Password");
    }
  }

  checkUserDetails() {
    if (emailController.text.isEmpty) {
      showingDialogMsg("Login Error", "Email Missing");
      return;
    }

    if (passwordController.text.isEmpty) {
      showingDialogMsg("Login Error", "Password Missing");
      return;
    }

    login();
  }

  Future<http.Response> loginUser() async {
    final url = Uri.parse('$base_url/users/login');
    // Prepare the body
    final body = jsonEncode({
      'email': emailController.text,
      'password': passwordController.text,
    });

    // Prepare the headers
    final headers = {'Content-Type': 'application/json'};

    // Make the POST request
    return http.post(url, headers: headers, body: body);
  }

  Future<dynamic> showingDialogMsg(String title, String msg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
