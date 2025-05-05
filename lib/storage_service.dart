
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> setPremium(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', value);
  }

  static Future<bool> getPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPremium') ?? false;
  }

  static Future<void> setAvatarCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('avatarCount', count);
  }

  static Future<int> getAvatarCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('avatarCount') ?? 0;
  }

  static Future<void> setLastResetDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastResetDate', date);
  }

  static Future<String?> getLastResetDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastResetDate');
  }
}
