import 'package:to_do_app_fl/screens/login.dart';
import 'package:to_do_app_fl/screens/main_screen.dart';
import 'package:to_do_app_fl/screens/register.dart';

class AppRoutes {
  static final pages = {
    login: (context) => const LoginScreen(),
    main: (context) => const MainWrapperScreen(),
    // editProfile: (context) => const MyProfile(),
    register: (context) => const RegisterSceen(),
  };

  static const login = '/';
  static const register = '/register';
  static const main = '/main';
  static const user = '/user';
}
