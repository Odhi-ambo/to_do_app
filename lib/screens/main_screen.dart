import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app_fl/controllers/bottom_navigation.dart';
import 'package:to_do_app_fl/screens/add_todo.dart';
import 'package:to_do_app_fl/screens/home.dart';
import 'package:to_do_app_fl/screens/profile.dart';

var screens = [AllTodosScreen(), AddNewTodo(), ProfileScreen()];

//controller will help us rebuild our UI with the clicked screen
// obx wraps only one child and helps rebuild UI even without stateful widgets
MainBottomNavigationController bottomNavigationController =
    Get.put(MainBottomNavigationController());

class MainWrapperScreen extends StatelessWidget {
  const MainWrapperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Center(
              child: screens[bottomNavigationController.selectedPage.value]),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        buttonBackgroundColor: Colors.white,
        color: Colors.white,
        items: const [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.add,
            size: 30,
            color: Colors.black,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.black,
          ),
        ],
        onTap: (index) {
          //we just access the updateFunction and give it index
          bottomNavigationController.updateSelectedPage(index);
        },
      ),
    );
  }
}
