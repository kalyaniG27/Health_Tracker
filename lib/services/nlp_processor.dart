import 'co2_calculator.dart';

class NLPProcessor {
  static Map<String, dynamic> processFoodInput(String input) {
    input = input.toLowerCase().trim();

    Map<String, dynamic> result = {
      'description': input,
      'mealType': _detectMealType(input),
      'ingredients': _extractIngredients(input),
      'quantity': _extractQuantity(input),
      'confidence': 0.8, // Default confidence
    };

    return result;
  }

  static Map<String, dynamic> processExerciseInput(String input) {
    input = input.toLowerCase().trim();

    Map<String, dynamic> result = {
      'description': input,
      'activityType': _detectActivityType(input),
      'duration': _extractDuration(input),
      'intensity': _detectIntensity(input),
      'confidence': 0.8,
    };

    return result;
  }

  static Map<String, dynamic> processActivityInput(String input) {
    input = input.toLowerCase().trim();

    Map<String, dynamic> result = {
      'description': input,
      'transportMode': CO2Calculator.detectTransportMode(input),
      'distance': CO2Calculator.estimateDistanceFromDescription(input),
      'purpose': _detectActivityPurpose(input),
      'confidence': 0.8,
    };

    return result;
  }

  static String _detectMealType(String input) {
    if (input.contains('breakfast') ||
        input.contains('morning') ||
        input.contains('coffee') && input.contains('toast')) {
      return 'breakfast';
    } else if (input.contains('lunch') ||
        input.contains('noon') ||
        input.contains('sandwich') && input.contains('salad')) {
      return 'lunch';
    } else if (input.contains('dinner') ||
        input.contains('evening') ||
        input.contains('night') ||
        input.contains('pasta') && input.contains('meat')) {
      return 'dinner';
    } else if (input.contains('snack') ||
        input.contains('small') ||
        input.length < 25) {
      return 'snack';
    }

    return 'other';
  }

  static String _detectActivityType(String input) {
    if (input.contains('walk')) return 'walking';
    if (input.contains('run') || input.contains('jog')) return 'running';
    if (input.contains('cycl') || input.contains('bike')) return 'cycling';
    if (input.contains('swim')) return 'swimming';
    if (input.contains('yoga') || input.contains('stretch')) return 'yoga';
    if (input.contains('weight') || input.contains('gym')) return 'strength';
    if (input.contains('cardio')) return 'cardio';
    if (input.contains('dance')) return 'dancing';
    if (input.contains('hike')) return 'hiking';
    if (input.contains('sport')) return 'sports';

    return 'other';
  }

  static int _extractDuration(String input) {
    final durationRegex = RegExp(r'(\d+)\s*(?:min|minute|hour|hr)');
    final match = durationRegex.firstMatch(input);

    if (match != null) {
      int duration = int.parse(match.group(1)!);
      if (input.contains('hour') || input.contains('hr')) {
        duration *= 60;
      }
      return duration;
    }

    // Estimate from context
    if (input.contains('quick') || input.contains('short')) return 15;
    if (input.contains('long') || input.contains('extended')) return 60;
    if (input.contains('hour')) return 60;

    return 30; // Default duration
  }

  static String _detectIntensity(String input) {
    if (input.contains('light') ||
        input.contains('easy') ||
        input.contains('slow') ||
        input.contains('walk')) {
      return 'light';
    } else if (input.contains('intense') ||
        input.contains('hard') ||
        input.contains('heavy') ||
        input.contains('sprint') ||
        input.contains('run')) {
      return 'high';
    }

    return 'moderate';
  }

  static List<String> _extractIngredients(String input) {
    List<String> ingredients = [];
    final commonIngredients = [
      'egg',
      'bread',
      'toast',
      'oatmeal',
      'apple',
      'banana',
      'orange',
      'chicken',
      'salad',
      'rice',
      'pasta',
      'milk',
      'yogurt',
      'cheese',
      'butter',
      'oil',
      'avocado',
      'nuts',
      'protein',
      'smoothie',
      'coffee'
    ];

    for (String ingredient in commonIngredients) {
      if (input.contains(ingredient)) {
        ingredients.add(ingredient);
      }
    }

    return ingredients;
  }

  static String _extractQuantity(String input) {
    final quantityRegex = RegExp(r'(\d+)\s*(\w+)');
    final match = quantityRegex.firstMatch(input);

    if (match != null) {
      return '${match.group(1)} ${match.group(2)}';
    }

    if (input.contains('half')) return 'half';
    if (input.contains('quarter')) return 'quarter';
    if (input.contains('small')) return 'small';
    if (input.contains('large')) return 'large';

    return 'regular';
  }

  static String _detectActivityPurpose(String input) {
    if (input.contains('work') ||
        input.contains('office') ||
        input.contains('commute')) {
      return 'commute';
    } else if (input.contains('store') ||
        input.contains('shop') ||
        input.contains('market')) {
      return 'shopping';
    } else if (input.contains('park') ||
        input.contains('walk') && input.contains('dog')) {
      return 'leisure';
    } else if (input.contains('exercise') || input.contains('workout')) {
      return 'exercise';
    }

    return 'other';
  }
}
