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
TextEditingController fullnameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController phoneController = TextEditingController();

//to access the state we initialize the constructor
UserDetailsController userDetailsController = Get.put(UserDetailsController());

String currentGreeting = "";

String getGreeting() {
  DateTime now = DateTime.now();
  int hour = now.hour;
  if (hour >= 1 && hour <= 12) {
    return "Good Morning";
  } else if (hour >= 12 && hour <= 16) {
    return "Good Afternoon";
  } else if (hour >= 16 && hour <= 21) {
    return "Good Evening";
  } else {
    return "Good Night";
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    fullnameController.text = userDetailsController.fullname.value;
    emailController.text = userDetailsController.email.value;
    passwordController.text = userDetailsController.password.value;
    phoneController.text = userDetailsController.phone.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${getGreeting()} ${userDetailsController.fullname.value}"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Update Your Account",
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 16,
                                        ),
                                        TextField(
                                          controller: fullnameController,
                                          decoration: InputDecoration(
                                            hintText: "fullname",
                                            labelText: "Enter Your Name",
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
                                          controller: emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            hintText: "email",
                                            labelText: "Enter Your Email",
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
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: "phone",
                                            labelText: "Enter Phone Number",
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
                                                  backgroundColor:
                                                      MaterialStateProperty
                                                          .all<Color>(Colors
                                                              .transparent), // Set your desired background color
                                                  minimumSize:
                                                      MaterialStateProperty
                                                          .all<Size>(Size(
                                                              double.infinity,
                                                              0)),
                                                ),
                                                onPressed: () {
                                                  checkUserDetails();
                                                },
                                                child: const Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Update Account",
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
                                      ],
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updateAccount() async {
    setState(() {
      isLoading = true;
    });
    var response = await updateUser();
    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacementNamed("/");
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to register user. Status code: ${response.statusCode}');
      showingDialogMsg("Registration Error Error", "Error creating account");
    }
  }

  checkUserDetails() {
    if (fullnameController.text.isEmpty) {
      showingDialogMsg("Registration Error", "Fullname Missing");
      return;
    }

    if (emailController.text.isEmpty) {
      showingDialogMsg("Registration Error", "Email Missing");
      return;
    }

    if (phoneController.text.isEmpty) {
      showingDialogMsg("Registration Error", "Phone Number Missing");
      return;
    }

    if (passwordController.text.isEmpty) {
      showingDialogMsg("Registration Error", "Password Missing");
      return;
    }

    updateAccount();
  }

  Future<http.Response> updateUser() async {
    var userId = userDetailsController.userId.value;

    final url = Uri.parse('$base_url/users/$userId');

    // Prepare the body
    final body = jsonEncode({
      'fullname': fullnameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
    });

    // Prepare the headers
    final headers = {'Content-Type': 'application/json'};

    // Make the PUT request

    return http.put(url, headers: headers, body: body);
  }

//for showing messages
  Future<dynamic> showingDialogMsg(String title, String msg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
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
