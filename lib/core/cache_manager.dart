import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  Future<bool> saveAccessToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CacheManagerKey.ACCESS_TOKEN.toString(), token);
    return true;
  }

  Future<bool> saveRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(CacheManagerKey.REFRESH_TOKEN.toString(), token);
    return true;
  }

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(CacheManagerKey.ACCESS_TOKEN.toString());
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(CacheManagerKey.REFRESH_TOKEN.toString());
  }
  
}

enum CacheManagerKey { ACCESS_TOKEN, REFRESH_TOKEN }