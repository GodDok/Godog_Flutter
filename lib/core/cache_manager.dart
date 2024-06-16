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

  Future<bool> saveReport(bool isReportCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(CacheManagerKey.REPORT.toString(), isReportCompleted);
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

  Future<bool?> getReport() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(CacheManagerKey.REPORT.toString());
  }

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}

enum CacheManagerKey { ACCESS_TOKEN, REFRESH_TOKEN, REPORT }
