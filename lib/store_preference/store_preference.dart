import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  Future<bool> setToken(String label, String token) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(label, token);
  }

  Future<String> getToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token") ?? '';
  }

  Future clearAll() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  Future<bool> setConfig(String label, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(label, value);
  }

  Future<String> getConfig(String label) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(label) ?? "";
  }

  Future<String> getRefreshToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("tokenRe") ?? '';
  }
}