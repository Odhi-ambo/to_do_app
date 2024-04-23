import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:to_do_app_fl/constants/server_url.dart';
import 'package:to_do_app_fl/controllers/userController.dart';

import 'package:to_do_app_fl/screens/main_screen.dart';

//to access the state we initialize the constructor
UserDetailsController userDetailsController = Get.put(UserDetailsController());

var owner_Email = userDetailsController.email.value;

class TodoListItem extends StatefulWidget {
  final Map<String, dynamic> todo;
  final VoidCallback onTap;

  TodoListItem({required this.todo, required this.onTap});

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
//update a todo
  void updateMyTodo(todoData) async {
    // Prepare the body
    final body = jsonEncode({
      'title': todoData["title"],
      'status': todoData["status"] == "done" ? "pending" : "done",
      'owner_Email': owner_Email, //signed in user
    });

    var todoId = todoData["id"];

    // Prepare the headers
    final headers = {'Content-Type': 'application/json'};

    // Make the PUT request
    final url = Uri.parse('$base_url/todos/$todoId');

    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MainWrapperScreen()));
    } else {
      print(body);
      print(url);
      throw Exception('Failed to update todo');
    }
  }

  //delete a todo
  void deleteMyTodo(todoData) async {
    var todoId = todoData["id"];
    // Prepare the headers
    final headers = {'Content-Type': 'application/json'};
    // Make the DELETE request
    final url = Uri.parse('$base_url/todos/$todoId');

    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MainWrapperScreen()));
    } else {
      print(url);
      throw Exception('Failed to delete todo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: ListTile(
        onTap: () {
          updateMyTodo(widget.todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.black12,
        leading: Icon(
          widget.todo["status"].toString() == "done"
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          color: Colors.blue,
        ),
        title: Text(
          widget.todo["title"].toString(),
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: widget.todo["status"].toString() == "done"
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteMyTodo(widget.todo);
            },
          ),
        ),
      ),
    );
  }
}
