import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:to_do_app_fl/constants/server_url.dart';
import 'package:to_do_app_fl/controllers/userController.dart';

bool isLoading = false;

//to access the state we initialize the constructor
UserDetailsController userDetailsController = Get.put(UserDetailsController());

//controllers to track inputs on text fields
TextEditingController titleController = TextEditingController();
var owner_Email = userDetailsController.email.value;

class AddNewTodo extends StatefulWidget {
  const AddNewTodo({super.key});

  @override
  State<AddNewTodo> createState() => _AddNewTodoState();
}

class _AddNewTodoState extends State<AddNewTodo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          // Wrap the SingleChildScrollView with a Center widget
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center the content vertically
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center the content horizontally
              children: [
                Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            "Add A New Todo",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              hintText: "todo title",
                              labelText: "Please Enter A Todo",
                              labelStyle: TextStyle(
                                fontSize: 20,
                              ),
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          isLoading
                              ? Center(
                                  child: Column(
                                    children: [
                                      LoadingAnimationWidget.newtonCradle(
                                          color: Colors.green, size: 50),
                                      const Text("Please wait")
                                    ],
                                  ),
                                )
                              : ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(double.infinity, 0)),
                                  ),
                                  onPressed: () {
                                    checkAllDetails();
                                  },
                                  child: const Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add New Todo",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkAllDetails() {
    if (titleController.text.isEmpty) {
      showingDialogMsg("Creation Error", "Title Missing");
      return;
    }

    handleCreate();
  }

  Future<void> handleCreate() async {
    setState(() {
      isLoading = true;
    });
    var response = await addNewTodo();
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      showingDialogMsg("Creation Success 🎉", "Added New");
      setState(() {
        titleController.text = "";
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to add. Status code: ${response.statusCode}');
      showingDialogMsg("Addition Error", "Error adding biz");
    }
  }

  Future<http.Response> addNewTodo() async {
    final url = Uri.parse('$base_url/todos');
    // Prepare the body
    final body = jsonEncode({
      'title': titleController.text,
      'status': "pending",
      'owner_Email': owner_Email,
    });

    // Prepare the headers
    final headers = {'Content-Type': 'application/json'};

    // Make the POST request
    return http.post(url, headers: headers, body: body);
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
