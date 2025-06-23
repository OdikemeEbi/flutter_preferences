import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _preferences;
  static const _keyCounter = 'conuter';
  static const _keyName = 'name';
  static const _keyAge = 'age';
  static const _keyFavouriteColor = 'favoriteColor';
  static const _keyNewFavouriteColor = 'newFavoriteColor';
  static const _keyIsSubscrubed = 'isSubscribed';

  /// Initializes the shared preferences instance. Must be called before using any other methods.
  static Future init() async => _preferences = await SharedPreferences.getInstance();

  /// Saves the user's name to shared preferences.
  static Future<bool> saveName(String nameValue) async {
    await _preferences.setString(_keyName, nameValue);
    return false;
  }

  /// Saves the user's age to shared preferences.
  static Future<bool> saveAge(int ageValue) => _preferences.setInt(_keyAge, ageValue);

  // return false;

  /// Saves the user's selected favorite color (from radio buttons) to shared preferences.
  static Future<bool> saveFavouriteColor(String color) => _preferences.setString(_keyFavouriteColor, color);

  /// Saves the user's favorite color (from text field) to shared preferences.
  static Future<bool> saveNewFavouriteColor(String color) => _preferences.setString(_keyNewFavouriteColor, color);

  /// Saves the user's subscription status to shared preferences.
  static Future<bool> saveSubScription(bool subscribe) async {
    return _preferences.setBool(_keyIsSubscrubed, subscribe);
  }

  /// Returns the user's name from shared preferences.
  static String? displayName() {
    _preferences.getString(_keyName);
    return '';
  }

  /// Returns the user's age from shared preferences.
  static int? displayAge() => _preferences.getInt(_keyAge);

  /// Returns the user's name from shared preferences.
  static String? getName() => _preferences.getString(_keyName);

  /// Returns the user's selected favorite color (from radio buttons) from shared preferences.
  static String? getFavouriteColor() => _preferences.getString(_keyFavouriteColor);

  /// Returns the user's favorite color (from text field) from shared preferences.
  static String? getNewFavouriteColor() => _preferences.getString(_keyNewFavouriteColor);

  /// Returns the user's subscription status from shared preferences.
  static bool? isSubscribed() => _preferences.getBool(_keyIsSubscrubed);
  // Method to get ..

  /// Saves the counter value to shared preferences.
  static Future saveCounter(int counter) async {
    return _preferences.setInt(_keyCounter, counter);
  }

  /// Returns the counter value from shared preferences.
  static int? getCounter() => _preferences.getInt(_keyCounter);

  /// Clears all data from shared preferences.
  static Future clearData() async {
    _preferences.clear();
  }

  /// Prints a message indicating that shared preferences have been initialized.
  static initCheck() {
    print('Shared preferences initialized');
  }
}
