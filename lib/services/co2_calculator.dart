class CO2Calculator {
  // CO2 emissions in kg per km for different transport modes
  static const Map<String, double> transportEmissions = {
    'car': 0.2,          // Average petrol car
    'bus': 0.1,          // Public transport
    'train': 0.05,       // Electric train
    'motorcycle': 0.1,   // Motorcycle
    'taxi': 0.2,         // Similar to car
    'walking': 0.0,      // No emissions
    'cycling': 0.0,      // No emissions
    'running': 0.0,      // No emissions
  };
  
  static double calculateCO2Saved(double distance, String transportMode) {
    String mode = transportMode.toLowerCase();
    
    // Default to car emissions if mode not found
    double emissionsPerKm = transportEmissions[mode] ?? transportEmissions['car']!;
    
    return distance * emissionsPerKm;
  }
  
  static double estimateDistanceFromDescription(String description) {
    description = description.toLowerCase();
    
    // Extract distance from description
    final distanceRegex = RegExp(r'(\d+(?:\.\d+)?)\s*(km|kilometer|mile)');
    final match = distanceRegex.firstMatch(description);
    
    if (match != null) {
      double distance = double.parse(match.group(1)!);
      String unit = match.group(2)!;
      
      // Convert miles to km if needed
      if (unit.contains('mile')) {
        distance *= 1.60934;
      }
      return distance;
    }
    
    // Estimate based on activity type and duration
    if (description.contains('walk')) {
      if (description.contains('30') || description.contains('half')) {
        return 2.0; // 30 min walk ≈ 2km
      } else if (description.contains('60') || description.contains('hour')) {
        return 4.0; // 60 min walk ≈ 4km
      } else if (description.contains('15')) {
        return 1.0; // 15 min walk ≈ 1km
      }
      return 2.0; // Default walk distance
    }
    
    if (description.contains('cycl')) {
      if (description.contains('30') || description.contains('half')) {
        return 8.0; // 30 min cycle ≈ 8km
      } else if (description.contains('60') || description.contains('hour')) {
        return 16.0; // 60 min cycle ≈ 16km
      } else if (description.contains('15')) {
        return 4.0; // 15 min cycle ≈ 4km
      }
      return 8.0; // Default cycle distance
    }
    
    if (description.contains('run')) {
      if (description.contains('30') || description.contains('half')) {
        return 5.0; // 30 min run ≈ 5km
      } else if (description.contains('60') || description.contains('hour')) {
        return 10.0; // 60 min run ≈ 10km
      } else if (description.contains('15')) {
        return 2.5; // 15 min run ≈ 2.5km
      }
      return 5.0; // Default run distance
    }
    
    return 1.0; // Default distance
  }
  
  static String detectTransportMode(String description) {
    description = description.toLowerCase();
    
    if (description.contains('walk')) return 'walking';
    if (description.contains('cycl') || description.contains('bike')) return 'cycling';
    if (description.contains('run') || description.contains('jog')) return 'running';
    if (description.contains('bus')) return 'bus';
    if (description.contains('train')) return 'train';
    if (description.contains('motorcycle')) return 'motorcycle';
    if (description.contains('taxi') || description.contains('uber')) return 'taxi';
    
    return 'car'; // Default mode
  }
  
  // Calculate environmental impact in tree equivalents
  static double calculateTreeEquivalence(double co2Saved) {
    // One tree absorbs approximately 21 kg of CO2 per year
    // Convert daily savings to annual tree equivalent
    return (co2Saved * 365) / 21;
  }
}