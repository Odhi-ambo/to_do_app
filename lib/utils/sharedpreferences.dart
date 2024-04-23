import "package:shared_preferences/shared_preferences.dart";

//shared preferences only store small amounts of data. Key value
//can include colors or user data
class MysharedPreferences {
  //writing the username / email we don't need to return anything hence void.
  Future<void> writeValue(key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(key, value); //writing
  }

  //reading returns something in this case the key we passed above
  Future<String> getValue(key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //check for null. if null return empty string or some string
    return sharedPreferences.getString(key) ?? '';
  }
}
