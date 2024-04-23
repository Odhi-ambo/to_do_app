import 'package:get/get.dart';

//we need the index and function to update
class MainBottomNavigationController extends GetxController {
  var selectedPage = 0.obs; //variable to track the current page

  //methd to update
  updateSelectedPage(indexPassed) {
    selectedPage.value = indexPassed;
  }
}
