class AppConstants {
  // Environmental Constants
  static const double co2PerKmCar = 0.2;
  static const double co2PerKmBus = 0.1;
  static const double co2PerKmTrain = 0.05;
  static const double co2PerKmMotorcycle = 0.1;
  
  // Health Constants
  static const int dailyCalorieGoalDefault = 2000;
  static const int dailyExerciseGoalDefault = 30; // minutes
  static const int dailyStepsGoalDefault = 10000;
  static const double dailyWalkingGoalDefault = 5.0; // km
  static const double weeklyCO2ReductionGoalDefault = 10.0; // kg
  
  // App Constants
  static const String appName = 'Health & Eco Tracker';
  static const String appVersion = '1.0.0';
  static const int dataRetentionDays = 365;
  
  // Meal Types
  static const List<String> mealTypes = [
    'breakfast',
    'lunch', 
    'dinner',
    'snack',
    'other'
  ];
  
  // Exercise Intensities
  static const List<String> exerciseIntensities = [
    'light',
    'moderate',
    'high'
  ];
  
  // Transport Modes
  static const List<String> transportModes = [
    'walking',
    'cycling',
    'running',
    'car',
    'bus',
    'train',
    'motorcycle',
    'taxi'
  ];
  
  // Activity Purposes
  static const List<String> activityPurposes = [
    'commute',
    'shopping',
    'leisure',
    'exercise',
    'other'
  ];
  
  // Gender Options
  static const List<String> genderOptions = [
    'male',
    'female',
    'other'
  ];
}