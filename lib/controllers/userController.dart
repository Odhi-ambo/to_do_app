import 'package:get/get.dart';

class UserDetailsController extends GetxController {
  var fullname = "".obs; //variable to track username
  var email = "".obs; //variable to track phone
  var userId = "".obs; //variable to track user id
  var phone = "".obs; //variable to track phone number
  var password = "".obs; //variable to track user pwd

  //methd to update
  updateUserDetails(newFullname, newEmail, newUserId, newPhone, newPassword) {
    fullname.value = newFullname;
    email.value = newEmail;
    userId.value = newUserId;
    phone.value = newPhone;
    password.value = newPassword;
  }
}
