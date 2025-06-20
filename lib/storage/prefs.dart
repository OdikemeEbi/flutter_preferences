import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _preferences;
  static const _keyCounter = 'conuter';
  static const _keyName = 'name';
  static const _keyAge = 'age';

  // Initialize Shared preferences
  static Future init() async => _preferences = await SharedPreferences.getInstance();

  static Future<bool> saveName(String nameValue) async {
    try {
      await _preferences.setString(_keyName, nameValue);

      print('Name saved $nameValue');
    } catch (e) {
      print('Error saving name $e');
    }
    return false;
  }

  static Future<bool> saveAge(int ageValue) =>
     _preferences.setInt(_keyAge, ageValue);

    // return false;
  

  static String? displayName() {
    _preferences.getString(_keyName);
    return '';
  }

  static int? displayAge() => _preferences.getInt(_keyAge);

  static String? getName() => _preferences.getString(_keyName);

  // Method to set or Save the counter to
  // our local storage
  static Future saveCounter(int counter) async {
    return _preferences.setInt(_keyCounter, counter);
  }

  // Method the get/display the saved counter
  // from our local storage
  static int? getCounter() => _preferences.getInt(_keyCounter);

  static Future clearData() async {
    _preferences.clear();
  }

  static initCheck() {
    print('Shared preferences initialized');
  }
}
