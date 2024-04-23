import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:to_do_app_fl/constants/server_url.dart';
import 'package:to_do_app_fl/controllers/userController.dart';
import 'package:to_do_app_fl/model/specifictodo.dart';

bool isLoading = false;

//to access the state we initialize the constructor
UserDetailsController userDetailsController = Get.put(UserDetailsController());

var owner_Email = userDetailsController.email.value;

class AllTodosScreen extends StatefulWidget {
  const AllTodosScreen({Key? key}) : super(key: key);

  @override
  _AllTodosScreenState createState() => _AllTodosScreenState();
}

class _AllTodosScreenState extends State<AllTodosScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredTodos = [];
  List<Map<String, dynamic>> todos = [];

  @override
  void initState() {
    super.initState();
    fetchMyTodos(); // Fetch todos when the widget initializes
  }

//fetch my todos
  void fetchMyTodos() async {
    setState(() {
      isLoading = true;
    });

    // Prepare the body
    final body = jsonEncode({
      'owner_Email': owner_Email,
    });

    print(body);

    // Prepare the headers
    final headers = {'Content-Type': 'application/json'};

    // Make the POST request
    final url = Uri.parse('$base_url/todos/mine');

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        todos = List<Map<String, dynamic>>.from(json.decode(response.body));
        // print(businesses);
        filteredTodos = List.from(todos);
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print(body);
      print(url);
      throw Exception('Failed to load todos');
    }
  }

  void _filterTodos(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTodos = List.from(todos);
      } else {
        filteredTodos = todos
            .where((todo) =>
                todo["title"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${userDetailsController.fullname.value}'s Todos"),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.halfTriangleDot(
                      color: Colors.black, size: 50),
                  const Text("Fetching ...")
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterTodos,
                    decoration: const InputDecoration(
                      hintText: 'Search Todo',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: filteredTodos.length > 0
                      ? ListView.builder(
                          itemCount: filteredTodos.length,
                          itemBuilder: (context, index) {
                            return TodoListItem(
                              todo: filteredTodos[index],
                              onTap: () {},
                            );
                          },
                        )
                      : IfNoDataToShow(), // This is your "no results" widget
                ),
              ],
            ),
    );
  }
}

//widget if no data to show
class IfNoDataToShow extends StatelessWidget {
  const IfNoDataToShow({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center content vertically
        children: [
          Image.asset(
            "assets/images/wave.png",
            height: 80,
          ),
          const SizedBox(
              height: 10), // Add some space between the image and the text
          const Text(
            "No Results Found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Try relogin or add new todo",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
