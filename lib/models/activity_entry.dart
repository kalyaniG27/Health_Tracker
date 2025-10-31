import 'log_entry.dart';

class ActivityEntry implements LogEntry {
  final String id;
  final String description;
  final double distance;
  final double co2Saved;
  @override
  final DateTime time;
  final String transportMode;
  final String purpose;

  ActivityEntry({
    required this.id,
    required this.description,
    required this.distance,
    required this.co2Saved,
    required this.time,
    required this.transportMode,
    this.purpose = 'other',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'distance': distance,
      'co2Saved': co2Saved,
      'time': time.toIso8601String(),
      'transportMode': transportMode,
      'purpose': purpose,
    };
  }

  factory ActivityEntry.fromJson(Map<String, dynamic> json) {
    return ActivityEntry(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      description: json['description'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      co2Saved: (json['co2Saved'] ?? 0).toDouble(),
      time: _parseDate(json['time']),
      transportMode: json['transportMode'] ?? 'walking',
      purpose: json['purpose'] ?? 'other',
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

  ActivityEntry copyWith({
    String? id,
    String? description,
    double? distance,
    double? co2Saved,
    DateTime? time,
    String? transportMode,
    String? purpose,
  }) {
    return ActivityEntry(
      id: id ?? this.id,
      description: description ?? this.description,
      distance: distance ?? this.distance,
      co2Saved: co2Saved ?? this.co2Saved,
      time: time ?? this.time,
      transportMode: transportMode ?? this.transportMode,
      purpose: purpose ?? this.purpose,
    );
  }
}
