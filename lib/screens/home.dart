import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App'),),
      body: Container(
        child: Text('This is the HomeScreen'),
      ),
    );
  }
}