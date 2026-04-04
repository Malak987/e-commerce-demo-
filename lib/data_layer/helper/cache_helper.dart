import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences prefs;

  static init() async {
    prefs = await SharedPreferences.getInstance();
  }

  set({required String key, required dynamic value}) {
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      prefs.setDouble(key, value);
    }
  }

  String? getString({required String key}) {
    return prefs.getString(key);
  }

  int? getInt({required String key}) {
    return prefs.getInt(key);
  }

  double? getDouble({required String key}) {
    return prefs.getDouble(key);
  }

  List<String>? getStringList({required String key}) {
    return prefs.getStringList(key);
  }

  dynamic getDynamic({required String key}) {
    return prefs.get(key);
  }


  bool? getBool({required String key}) {
    return prefs.getBool(key);
  }

  void remove({required String key}) {
    prefs.remove(key);
  }
  void clear() {
    prefs.clear();
  }

}
