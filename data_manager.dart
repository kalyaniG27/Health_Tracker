import 'package:flutter/material.dart';
import '../models/food_entry.dart';
import '../models/exercise_entry.dart';
import '../models/activity_entry.dart';
import '../services/local_storage.dart';
import '../services/nlp_processor.dart';
import '../services/calorie_calculator.dart';
import '../services/co2_calculator.dart';

class DataManager extends ChangeNotifier {
  List<FoodEntry> _foodEntries = [];
  List<ExerciseEntry> _exerciseEntries = [];
  List<ActivityEntry> _activityEntries = [];
  bool _isLoading = false;

  List<FoodEntry> get foodEntries => _foodEntries;
  List<ExerciseEntry> get exerciseEntries => _exerciseEntries;
  List<ActivityEntry> get activityEntries => _activityEntries;
  bool get isLoading => _isLoading;

  DataManager() {
    loadAllEntries();
  }

  Future<void> loadAllEntries() async {
    _isLoading = true;
    notifyListeners();

    _foodEntries = await LocalStorage.getFoodEntries();
    _exerciseEntries = await LocalStorage.getExerciseEntries();
    _activityEntries = await LocalStorage.getActivityEntries();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addFoodEntry(String description) async {
    final processed = NLPProcessor.processFoodInput(description);
    final calories = CalorieCalculator.estimateFoodCalories(description);

    final newEntry = FoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: description,
      calories: calories,
      time: DateTime.now(),
      mealType: processed['mealType'] ?? 'other',
    );

    _foodEntries.add(newEntry);
    await LocalStorage.saveFoodEntries(_foodEntries);
    notifyListeners();
  }

  // TODO: Implement addExerciseEntry using NLPProcessor and CalorieCalculator
  Future<void> addExerciseEntry(String description) async {
    // ... similar to addFoodEntry
  }

  // TODO: Implement addActivityEntry using NLPProcessor and CO2Calculator
  Future<void> addActivityEntry(String description) async {
    // ... similar to addFoodEntry
  }

  int get totalCaloriesToday {
    final today = DateTime.now();
    return _foodEntries
        .where((entry) =>
            entry.time.year == today.year &&
            entry.time.month == today.month &&
            entry.time.day == today.day)
        .fold(0, (sum, entry) => sum + entry.calories);
  }
}
