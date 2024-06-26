import 'package:flutter/material.dart';
import 'package:to_do_app_fl/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      initialRoute: AppRoutes.login,
      routes: AppRoutes.pages,
    );
  }
}
