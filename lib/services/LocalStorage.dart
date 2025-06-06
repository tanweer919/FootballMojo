import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<String?> getString(String key) async { // Return type is now String?
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.getString(key) already returns String?
    final String? value = prefs.getString(key);
    return value;
  }

  static Future<List<String>?> getStringList(String key) async { // Return type is now List<String>?
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.getStringList(key) already returns List<String>?
    final List<String>? value = prefs.getStringList(key);
    return value;
  }

  static Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<void> setStringList(String key, List<String> value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }
}