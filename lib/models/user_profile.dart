class UserProfile {
  final String id;
  final String name;
  final double weight;
  final double height;
  final int age;
  final String gender;
  final Map<String, dynamic> goals;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.age,
    required this.gender,
    required this.goals,
    required this.createdAt,
  });

  factory UserProfile.createNew({
    required String name,
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) {
    return UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      weight: weight,
      height: height,
      age: age,
      gender: gender,
      goals: {
        'dailyCalories': 2000,
        'dailyExercise': 30, // minutes
        'dailySteps': 10000,
        'dailyWalking': 5.0, // km
        'weeklyCO2Reduction': 10.0, // kg
      },
      createdAt: DateTime.now(),
    );
  }

  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'goals': goals,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? 'User',
      weight: (json['weight'] ?? 70.0).toDouble(),
      height: (json['height'] ?? 170.0).toDouble(),
      age: json['age'] ?? 25,
      gender: json['gender'] ?? 'male',
      goals: Map<String, dynamic>.from(json['goals'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    double? weight,
    double? height,
    int? age,
    String? gender,
    Map<String, dynamic>? goals,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      goals: goals ?? this.goals,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}