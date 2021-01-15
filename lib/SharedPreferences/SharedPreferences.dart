import 'package:shared_preferences/shared_preferences.dart';

const USER_EMAIL = 'USEREMAIL';
const USER_PASSWORD = 'USERPASSWORD';

getUserEmail() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(USER_EMAIL);
}

getUserPassword() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(USER_PASSWORD);
}

setUserEmail(String email) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setString(USER_EMAIL, email);
}

setUserPassword(String password) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.setString(USER_PASSWORD, password);
}
