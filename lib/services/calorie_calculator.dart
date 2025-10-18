class CalorieCalculator {
  static int estimateFoodCalories(String description) {
    description = description.toLowerCase();

    // Food items with estimated calories
    final foodCalories = {
      'egg': 70,
      'eggs': 70,
      'toast': 80,
      'bread': 80,
      'slice of bread': 80,
      'oatmeal': 150,
      'porridge': 150,
      'apple': 95,
      'banana': 105,
      'orange': 62,
      'chicken': 250,
      'chicken breast': 250,
      'salad': 200,
      'green salad': 150,
      'rice': 200,
      'white rice': 200,
      'brown rice': 215,
      'pasta': 200,
      'spaghetti': 200,
      'milk': 120,
      'glass of milk': 120,
      'yogurt': 150,
      'greek yogurt': 150,
      'cheese': 110,
      'slice of cheese': 110,
      'butter': 100,
      'tablespoon butter': 100,
      'oil': 120,
      'tablespoon oil': 120,
      'avocado': 240,
      'nuts': 180,
      'handful of nuts': 180,
      'protein shake': 200,
      'smoothie': 250,
      'coffee': 5,
      'tea': 2,
      'water': 0,
    };

    // Quantity multipliers
    final quantityPatterns = {
      'half': 0.5,
      'quarter': 0.25,
      'small': 0.7,
      'large': 1.3,
      'extra large': 1.5,
      '2': 2,
      'two': 2,
      '3': 3,
      'three': 3,
      '4': 4,
      'four': 4,
      '5': 5,
      'five': 5,
    };

    double multiplier = 1.0;
    int totalCalories = 0;

    // Check for quantities
    quantityPatterns.forEach((pattern, value) {
      if (description.contains(pattern)) {
        multiplier = value.toDouble();
      }
    });

    // Calculate calories based on food items
    foodCalories.forEach((food, calories) {
      if (description.contains(food)) {
        totalCalories += (calories * multiplier).round();
      }
    });

    // Default estimation based on meal size
    if (totalCalories == 0) {
      if (description.contains('snack') || description.length < 20) {
        totalCalories = 150;
      } else if (description.contains('meal') || description.length > 40) {
        totalCalories = 500;
      } else {
        totalCalories = 300;
      }
    }

    return totalCalories;
  }

  static int estimateExerciseCalories(String description, {double? weight}) {
    description = description.toLowerCase();
    weight = weight ?? 70.0; // Default weight 70kg

    // Base calories per minute for different activities
    final activityRates = {
      'walk': 4.0,
      'walking': 4.0,
      'run': 10.0,
      'running': 10.0,
      'jog': 8.0,
      'jogging': 8.0,
      'cycl': 8.0,
      'bike': 8.0,
      'biking': 8.0,
      'cycling': 8.0,
      'swim': 8.0,
      'swimming': 8.0,
      'yoga': 3.0,
      'stretch': 3.0,
      'stretching': 3.0,
      'weight': 5.0,
      'weights': 5.0,
      'gym': 5.0,
      'workout': 5.0,
      'cardio': 7.0,
      'dance': 5.0,
      'dancing': 5.0,
      'hike': 6.0,
      'hiking': 6.0,
      'sport': 7.0,
      'tennis': 7.0,
      'basketball': 8.0,
      'soccer': 8.0,
      'football': 8.0,
    };

    // Extract duration
    int duration = 30; // Default 30 minutes
    final durationRegex = RegExp(r'(\d+)\s*min');
    final match = durationRegex.firstMatch(description);
    if (match != null) {
      duration = int.parse(match.group(1)!);
    } else {
      // Estimate from description
      if (description.contains('hour') || description.contains('60')) {
        duration = 60;
      } else if (description.contains('45')) {
        duration = 45;
      } else if (description.contains('15') || description.contains('quick')) {
        duration = 15;
      } else if (description.contains('long') ||
          description.contains('extended')) {
        duration = 60;
      }
    }

    // Find matching activity
    double caloriesPerMinute = 5.0; // Default moderate activity
    activityRates.forEach((activity, rate) {
      if (description.contains(activity)) {
        caloriesPerMinute = rate;
      }
    });

    // Adjust for weight (based on 70kg reference)
    double weightFactor = weight / 70.0;

    return (caloriesPerMinute * duration * weightFactor).round();
  }
}
