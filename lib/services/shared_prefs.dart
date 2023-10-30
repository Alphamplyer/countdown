
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String lastCountdownIdKey = 'LAST_COUNTDOWN_ID';
  static SharedPreferences? _sharedPrefs;

  static Future<void> init() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  static Future<int?> getInt(String key) async {
    return _sharedPrefs!.getInt(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _sharedPrefs!.setInt(key, value);
  }

  static Future<String?> getString(String key) async {
    return _sharedPrefs!.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    await _sharedPrefs!.setString(key, value);
  }
}