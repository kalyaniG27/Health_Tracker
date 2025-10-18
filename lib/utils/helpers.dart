class Validators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    return null;
  }
  
  // Name Validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    
    return null;
  }
  
  // Weight Validation
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter weight';
    }
    
    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Please enter a valid weight';
    }
    
    if (weight <= 0 || weight > 500) {
      return 'Please enter a valid weight (0-500 kg)';
    }
    
    return null;
  }
  
  // Height Validation
  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter height';
    }
    
    final height = double.tryParse(value);
    if (height == null) {
      return 'Please enter a valid height';
    }
    
    if (height <= 0 || height > 300) {
      return 'Please enter a valid height (0-300 cm)';
    }
    
    return null;
  }
  
  // Age Validation
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter age';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age <= 0 || age >= 150) {
      return 'Please enter a valid age (1-150)';
    }
    
    return null;
  }
  
  // Food Description Validation
  static String? validateFoodDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please describe what you ate';
    }
    
    if (value.length < 3) {
      return 'Description must be at least 3 characters long';
    }
    
    return null;
  }
  
  // Exercise Description Validation
  static String? validateExerciseDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please describe your exercise';
    }
    
    if (value.length < 3) {
      return 'Description must be at least 3 characters long';
    }
    
    return null;
  }
  
  // Activity Description Validation
  static String? validateActivityDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please describe your activity';
    }
    
    if (value.length < 3) {
      return 'Description must be at least 3 characters long';
    }
    
    return null;
  }
  
  // General Required Field Validation
  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }
  
  // Numeric Range Validation
  static String? validateNumericRange(
    String? value, {
    required double min,
    required double max,
    required String fieldName,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    
    final numericValue = double.tryParse(value);
    if (numericValue == null) {
      return 'Please enter a valid number for $fieldName';
    }
    
    if (numericValue < min || numericValue > max) {
      return '$fieldName must be between $min and $max';
    }
    
    return null;
  }
}