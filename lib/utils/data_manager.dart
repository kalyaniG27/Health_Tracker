import 'package:flutter/material.dart';
import 'package:health_tracker_app/models/food_entry.dart';
import 'package:health_tracker_app/models/exercise_entry.dart';
import 'package:health_tracker_app/models/log_entry.dart';
import 'package:health_tracker_app/models/activity_entry.dart';
import 'package:health_tracker_app/models/user_profile.dart';
import 'package:health_tracker_app/services/local_storage.dart';
import 'package:health_tracker_app/services/calorie_calculator.dart';
import 'package:health_tracker_app/services/co2_calculator.dart';

class DataManager extends ChangeNotifier {
  List<FoodEntry> _foodEntries = [];
  List<ExerciseEntry> _exerciseEntries = [];
  List<ActivityEntry> _activityEntries = [];
  UserProfile? _userProfile;
  Map<String, dynamic> _appSettings = {};
  bool _isLoading = false;

  List<FoodEntry> get foodEntries => _foodEntries;
  List<ExerciseEntry> get exerciseEntries => _exerciseEntries;
  List<ActivityEntry> get activityEntries => _activityEntries;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  Map<String, dynamic> get appSettings => _appSettings;

  DataManager() {
    loadAllEntries();
  }

  // --- Data Loading ---
  Future<void> loadAllEntries() async {
    _isLoading = true;
    notifyListeners();

    _foodEntries = await LocalStorage.getFoodEntries();
    _exerciseEntries = await LocalStorage.getExerciseEntries();
    _activityEntries = await LocalStorage.getActivityEntries();
    _userProfile = await LocalStorage.getUserProfile();
    _appSettings = await LocalStorage.getAppSettings();

    _isLoading = false;
    notifyListeners();
  }

  // --- Data Refreshing ---
  Future<void> refreshData() async {
    await loadAllEntries();
  }

  Future<void> fetchAllData() async {
    await loadAllEntries();
  }

  // --- Entry Addition ---
  Future<void> addFoodEntry(String description) async {
    final calories = CalorieCalculator.estimateFoodCalories(description);

    final newEntry = FoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      calories: calories,
      time: DateTime.now(),
      mealType: 'other', // Simplified
    );

    _foodEntries.insert(
        0, newEntry); // Insert at the beginning for newest first
    await LocalStorage.saveFoodEntries(_foodEntries);
    notifyListeners();
  }

  Future<void> addExerciseEntry(String description) async {
    final caloriesBurned = CalorieCalculator.estimateExerciseCalories(
      description,
      weight: _userProfile?.weight,
    );

    final newEntry = ExerciseEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      caloriesBurned: caloriesBurned,
      time: DateTime.now(),
      duration: 30, // Simplified
      intensity: 'moderate', // Simplified
    );

    _exerciseEntries.insert(0, newEntry);
    await LocalStorage.saveExerciseEntries(_exerciseEntries);
    notifyListeners();
  }

  Future<void> addActivityEntry(String description) async {
    final distance = 1.0; // Simplified
    final co2Saved = CO2Calculator.calculateCO2Saved(
      distance,
      'walking',
    );

    final newEntry = ActivityEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      distance: distance,
      co2Saved: co2Saved,
      time: DateTime.now(),
      transportMode: 'walking',
      purpose: 'other', // Simplified
    );

    _activityEntries.insert(0, newEntry);
    await LocalStorage.saveActivityEntries(_activityEntries);
    notifyListeners();
  }

  // --- Entry Deletion ---
  Future<void> deleteFoodEntry(FoodEntry entry) async {
    _foodEntries.removeWhere((e) => e.id == entry.id);
    await LocalStorage.saveFoodEntries(_foodEntries);
    notifyListeners();
  }

  Future<void> deleteExerciseEntry(ExerciseEntry entry) async {
    _exerciseEntries.removeWhere((e) => e.id == entry.id);
    await LocalStorage.saveExerciseEntries(_exerciseEntries);
    notifyListeners();
  }

  Future<void> deleteActivityEntry(ActivityEntry entry) async {
    _activityEntries.removeWhere((e) => e.id == entry.id);
    await LocalStorage.saveActivityEntries(_activityEntries);
    notifyListeners();
  }

  // --- Settings ---
  Future<void> updateSetting(String key, dynamic value) async {
    _appSettings[key] = value;
    await LocalStorage.saveAppSettings(_appSettings);
    notifyListeners();
  }

  // --- Daily Summary Getters ---
  List<LogEntry> get recentEntries {
    final allEntries = [
      ..._foodEntries,
      ..._exerciseEntries,
      ..._activityEntries
    ];
    allEntries.sort((a, b) => b.time.compareTo(a.time));
    return allEntries.take(5).toList();
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  int get totalCaloriesToday {
    return _foodEntries
        .where((entry) => _isToday(entry.time))
        .fold(0, (sum, entry) => sum + entry.calories);
  }

  int get totalCaloriesBurnedToday {
    return _exerciseEntries
        .where((entry) => _isToday(entry.time))
        .fold(0, (sum, entry) => sum + entry.caloriesBurned);
  }

  double get totalCo2SavedToday {
    return _activityEntries
        .where((entry) => _isToday(entry.time))
        .fold(0.0, (sum, entry) => sum + entry.co2Saved);
  }

  int get netCaloriesToday => totalCaloriesToday - totalCaloriesBurnedToday;

  // --- Weekly/Trend Insights ---
  bool _isWithinLast7Days(DateTime date) {
    final now = DateTime.now();
    // Use midnight of 7 days ago to include the full 7th day
    final sevenDaysAgo = DateTime(now.year, now.month, now.day - 6);
    return !date.isBefore(sevenDaysAgo);
  }

  int _getUniqueDaysWithEntries(List<LogEntry> entries) {
    if (entries.isEmpty) return 1; // Avoid division by zero
    final uniqueDays = entries
        .map((e) => DateTime(e.time.year, e.time.month, e.time.day))
        .toSet();
    return uniqueDays.length;
  }

  double get averageDailyCaloriesWeekly {
    final weeklyEntries =
        _foodEntries.where((e) => _isWithinLast7Days(e.time)).toList();
    if (weeklyEntries.isEmpty) return 0;
    final totalCals = weeklyEntries.fold(0, (sum, e) => sum + e.calories);
    final uniqueDays = _getUniqueDaysWithEntries(weeklyEntries);
    return totalCals / uniqueDays;
  }

  double get averageDailyExerciseWeekly {
    final weeklyEntries =
        _exerciseEntries.where((e) => _isWithinLast7Days(e.time)).toList();
    if (weeklyEntries.isEmpty) return 0;
    final totalDuration = weeklyEntries.fold(0, (sum, e) => sum + e.duration);
    final uniqueDays = _getUniqueDaysWithEntries(weeklyEntries);
    return totalDuration / uniqueDays;
  }

  double get totalCo2SavedWeekly {
    return _activityEntries
        .where((e) => _isWithinLast7Days(e.time))
        .fold(0.0, (sum, e) => sum + e.co2Saved);
  }

  double get totalDistanceWalkedWeekly {
    return _activityEntries
        .where((e) =>
            _isWithinLast7Days(e.time) &&
            (e.transportMode == 'walking' || e.transportMode == 'running'))
        .fold(0.0, (sum, e) => sum + e.distance);
  }

  double get netCalorieBalanceWeekly =>
      averageDailyCaloriesWeekly -
      (averageDailyExerciseWeekly * 5); // Rough estimate
}
