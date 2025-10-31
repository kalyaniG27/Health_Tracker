import 'log_entry.dart';

class FoodEntry implements LogEntry {
  final String id;
  final String description;
  final int calories;
  @override
  final DateTime time;
  final String mealType;

  FoodEntry({
    required this.id,
    required this.description,
    required this.calories,
    required this.time,
    this.mealType = 'other',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'calories': calories,
      'time': time.toIso8601String(),
      'mealType': mealType,
    };
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) {
    return FoodEntry(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      description: json['description'] ?? '',
      calories: json['calories'] ?? 0,
      time: _parseDate(json['time']),
      mealType: json['mealType'] ?? 'other',
    );
  }

  static DateTime _parseDate(dynamic dateString) {
    if (dateString == null || dateString.toString().isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString.toString());
    } catch (e) {
      return DateTime.now();
    }
  }

  FoodEntry copyWith({
    String? id,
    String? description,
    int? calories,
    DateTime? time,
    String? mealType,
  }) {
    return FoodEntry(
      id: id ?? this.id,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      time: time ?? this.time,
      mealType: mealType ?? this.mealType,
    );
  }
}
