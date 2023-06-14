import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Save user ID
  static Future<void> saveUserId(String id) async {
    await prefs!.setString("userId", id);
  }

  // Get user ID
  static String getUserId() {
    return prefs!.getString("userId") ?? "";
  }

  // Save Name of the user
  static Future<void> saveUserName(String name) async {
    await prefs!.setString("name", name);
  }

  // Get Name of the user
  static String getUserName() {
    return prefs!.getString("name") ?? "";
  }

  // Save Email of the user
  static Future<void> saveUserEmail(String email) async {
    await prefs!.setString("email", email);
  }

  // Get Email of the user
  static String getUserEmail() {
    return prefs!.getString("email") ?? "";
  }
}
