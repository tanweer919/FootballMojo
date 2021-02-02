import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<String> getString(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String value = (prefs.getString(key) ?? null);
    return value;
  }

  static Future<List<String>> getStringList(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> value = (prefs.getStringList(key) ?? null);
    return value;
  }

  static Future<void> setString(String key, String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<void> setStringList(String key, List<String> value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, value);
  }
}