import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_entry.dart';
import '../models/exercise_entry.dart';
import '../models/activity_entry.dart';
import '../models/user_profile.dart';

class LocalStorage {
  static const _foodKey = 'food_entries';
  static const _exerciseKey = 'exercise_entries';
  static const _activityKey = 'activity_entries';
  static const _profileKey = 'user_profile';
  static const _settingsKey = 'app_settings';

  static Future<void> _saveList(String key, List<dynamic> list) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = list.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(key, stringList);
  }

  static Future<List<T>> _getList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final prefs = await SharedPreferences.getInstance();
    final stringList = prefs.getStringList(key) ?? [];
    return stringList
        .map((item) => fromJson(json.decode(item)))
        .toList()
        .cast<T>();
  }

  // Food
  static Future<void> saveFoodEntries(List<FoodEntry> entries) =>
      _saveList(_foodKey, entries);
  static Future<List<FoodEntry>> getFoodEntries() =>
      _getList(_foodKey, (json) => FoodEntry.fromJson(json));

  // Exercise
  static Future<void> saveExerciseEntries(List<ExerciseEntry> entries) =>
      _saveList(_exerciseKey, entries);
  static Future<List<ExerciseEntry>> getExerciseEntries() =>
      _getList(_exerciseKey, (json) => ExerciseEntry.fromJson(json));

  // Activity
  static Future<void> saveActivityEntries(List<ActivityEntry> entries) =>
      _saveList(_activityKey, entries);
  static Future<List<ActivityEntry>> getActivityEntries() =>
      _getList(_activityKey, (json) => ActivityEntry.fromJson(json));

  // User Profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
  }

  static Future<UserProfile> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileKey);
    if (jsonString != null) {
      return UserProfile.fromJson(json.decode(jsonString));
    }
    // Return a default profile if none exists
    return UserProfile.createNew(
        name: 'User', weight: 70, height: 170, age: 25, gender: 'other');
  }

  // App Settings
  static Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, json.encode(settings));
  }

  static Future<Map<String, dynamic>> getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString != null) {
      return json.decode(jsonString);
    }
    // Return default settings if none exist
    return {'darkMode': false, 'notifications': true};
  }
}
