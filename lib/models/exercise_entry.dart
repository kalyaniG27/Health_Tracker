import 'log_entry.dart';

class ExerciseEntry implements LogEntry {
  final String id;
  final String description;
  final int caloriesBurned;
  @override
  final DateTime time;
  final int duration;
  final String intensity;

  ExerciseEntry({
    required this.id,
    required this.description,
    required this.caloriesBurned,
    required this.time,
    required this.duration,
    this.intensity = 'moderate',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'caloriesBurned': caloriesBurned,
      'time': time.toIso8601String(),
      'duration': duration,
      'intensity': intensity,
    };
  }

  factory ExerciseEntry.fromJson(Map<String, dynamic> json) {
    return ExerciseEntry(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      description: json['description'] ?? '',
      caloriesBurned: json['caloriesBurned'] ?? 0,
      time: _parseDate(json['time']),
      duration: json['duration'] ?? 30,
      intensity: json['intensity'] ?? 'moderate',
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

  ExerciseEntry copyWith({
    String? id,
    String? description,
    int? caloriesBurned,
    DateTime? time,
    int? duration,
    String? intensity,
  }) {
    return ExerciseEntry(
      id: id ?? this.id,
      description: description ?? this.description,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      time: time ?? this.time,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
    );
  }
}
