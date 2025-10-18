import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/food_entry.dart';
import '../models/exercise_entry.dart';
import '../models/activity_entry.dart';
import '../models/user_profile.dart';

class LocalStorage {
  static const String _foodEntriesKey = 'food_entries';
  static const String _exerciseEntriesKey = 'exercise_entries';
  static const String _activityEntriesKey = 'activity_entries';
  static const String _userProfileKey = 'user_profile';
  static const String _appSettingsKey = 'app_settings';

  // Food Entries
  static Future<void> saveFoodEntries(List<FoodEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = entries.map((entry) => entry.toJson()).toList();
    await prefs.setString(_foodEntriesKey, json.encode(entriesJson));
  }

  static Future<List<FoodEntry>> getFoodEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_foodEntriesKey);

    if (entriesJson == null) return [];

    try {
      final List<dynamic> decoded = json.decode(entriesJson);
      return decoded.map((json) => FoodEntry.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading food entries: $e');
      return [];
    }
  }

  // Exercise Entries
  static Future<void> saveExerciseEntries(List<ExerciseEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = entries.map((entry) => entry.toJson()).toList();
    await prefs.setString(_exerciseEntriesKey, json.encode(entriesJson));
  }

  static Future<List<ExerciseEntry>> getExerciseEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_exerciseEntriesKey);

    if (entriesJson == null) return [];

    try {
      final List<dynamic> decoded = json.decode(entriesJson);
      return decoded.map((json) => ExerciseEntry.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading exercise entries: $e');
      return [];
    }
  }

  // Activity Entries
  static Future<void> saveActivityEntries(List<ActivityEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = entries.map((entry) => entry.toJson()).toList();
    await prefs.setString(_activityEntriesKey, json.encode(entriesJson));
  }

  static Future<List<ActivityEntry>> getActivityEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_activityEntriesKey);

    if (entriesJson == null) return [];

    try {
      final List<dynamic> decoded = json.decode(entriesJson);
      return decoded.map((json) => ActivityEntry.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading activity entries: $e');
      return [];
    }
  }

  // User Profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, json.encode(profile.toJson()));
  }

  static Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);

    if (profileJson == null) return null;

    try {
      final Map<String, dynamic> decoded = json.decode(profileJson);
      return UserProfile.fromJson(decoded);
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      return null;
    }
  }

  // App Settings
  static Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_appSettingsKey, json.encode(settings));
  }

  static Future<Map<String, dynamic>> getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_appSettingsKey);

    if (settingsJson == null) {
      return {
        'notifications': true,
        'darkMode': false,
        'healthSync': true,
        'ecoData': true,
      };
    }

    try {
      final Map<String, dynamic> decoded = json.decode(settingsJson);
      return decoded;
    } catch (e) {
      debugPrint('Error loading app settings: $e');
      return {
        'notifications': true,
        'darkMode': false,
        'healthSync': true,
        'ecoData': true,
      };
    }
  }

  // Clear all data (for testing/reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_foodEntriesKey);
    await prefs.remove(_exerciseEntriesKey);
    await prefs.remove(_activityEntriesKey);
    await prefs.remove(_userProfileKey);
    await prefs.remove(_appSettingsKey);
  }

  // Get storage statistics
  static Future<Map<String, int>> getStorageStats() async {
    final foodEntries = await getFoodEntries();
    final exerciseEntries = await getExerciseEntries();
    final activityEntries = await getActivityEntries();

    return {
      'foodEntries': foodEntries.length,
      'exerciseEntries': exerciseEntries.length,
      'activityEntries': activityEntries.length,
      'totalEntries':
          foodEntries.length + exerciseEntries.length + activityEntries.length,
    };
  }
}
