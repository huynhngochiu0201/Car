import 'dart:convert';
import 'package:app_car_rescue/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String userKey = 'user';

  static late SharedPreferences _prefs;

  static Future<void> initialise() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isAccessed => _prefs.getBool('checkAccess') ?? false;

  static set isAccessed(bool value) => _prefs.setBool('checkAccess', value);

  static bool get isLogin {
    String? data = _prefs.getString(userKey);
    if (data == null) return false;
    return true;
  }

  static UserModel? get user {
    String? data = _prefs.getString(userKey);
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data));
  }

  static set user(UserModel? user) {
    _prefs.setString(userKey, jsonEncode(user?.toJson()));
  }

  static removeSeason() {
    _prefs.remove(userKey);
  }

  static Future<void> saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }

  static Future<String?> loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('language_code') ?? 'en';
  }
}
