// pages/insights.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/data_manager.dart';
import '../theme/text_styles.dart';
import '../services/co2_calculator.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Health & Environmental Insights')),
      body: dataManager.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health Insights
                  _buildSectionTitle('Health Insights', context),
                  _buildHealthInsights(dataManager),

                  const SizedBox(height: 20),

                  // Environmental Impact
                  _buildSectionTitle('Environmental Impact', context),
                  _buildEnvironmentalImpact(dataManager),

                  const SizedBox(height: 20),

                  // Weekly Progress
                  _buildSectionTitle('Weekly Progress', context),
                  _buildWeeklyProgress(dataManager),

                  const SizedBox(height: 20),

                  // Recommendations
                  _buildSectionTitle('Personalized Recommendations', context),
                  _buildRecommendations(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyles.heading5
          .copyWith(color: Theme.of(context).primaryColorDark),
    );
  }

  Widget _buildHealthInsights(DataManager dataManager) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInsightItem(
                'Avg Daily Calories',
                '${dataManager.averageDailyCaloriesWeekly.toStringAsFixed(0)} kcal',
                Icons.restaurant),
            _buildInsightItem(
                'Avg Daily Exercise',
                '${dataManager.averageDailyExerciseWeekly.toStringAsFixed(0)} min/day',
                Icons.directions_run),
            _buildInsightItem(
                'Net Calorie Balance',
                '${dataManager.netCalorieBalanceWeekly.toStringAsFixed(0)} kcal/day',
                Icons.trending_down),
            _buildInsightItem(
                'Weekly Weight Trend', '-0.5 kg', Icons.monitor_weight),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvironmentalImpact(DataManager dataManager) {
    final treesEquivalent =
        CO2Calculator.calculateTreeEquivalence(dataManager.totalCo2SavedWeekly);
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildImpactItem(
                'Total CO₂ Saved (7d)',
                '${dataManager.totalCo2SavedWeekly.toStringAsFixed(2)} kg',
                Icons.eco),
            _buildImpactItem('Equivalent Trees (Annualized)',
                '${treesEquivalent.toStringAsFixed(1)} trees', Icons.park),
            _buildImpactItem(
                'Distance Walked (7d)',
                '${dataManager.totalDistanceWalkedWeekly.toStringAsFixed(1)} km',
                Icons.directions_walk),
            _buildImpactItem(
                'Car Trips Avoided', '12 trips', Icons.directions_car),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgress(DataManager dataManager) {
    final calorieGoal =
        dataManager.userProfile?.goals['dailyCalories']?.toDouble() ?? 2000.0;
    final exerciseGoal =
        dataManager.userProfile?.goals['dailyExercise']?.toDouble() ?? 30.0;
    final walkingGoal =
        dataManager.userProfile?.goals['dailyWalking']?.toDouble() ?? 5.0;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProgressBar(
                'Avg Calorie Goal',
                dataManager.averageDailyCaloriesWeekly / calorieGoal,
                '${dataManager.averageDailyCaloriesWeekly.toStringAsFixed(0)} / ${calorieGoal.toStringAsFixed(0)} kcal'),
            const SizedBox(height: 10),
            _buildProgressBar(
                'Avg Exercise Goal',
                dataManager.averageDailyExerciseWeekly / exerciseGoal,
                '${dataManager.averageDailyExerciseWeekly.toStringAsFixed(0)} / ${exerciseGoal.toStringAsFixed(0)} min'),
            const SizedBox(height: 10),
            _buildProgressBar(
                'Avg Walking Goal',
                (dataManager.totalDistanceWalkedWeekly / 7) / walkingGoal,
                '${(dataManager.totalDistanceWalkedWeekly / 7).toStringAsFixed(1)} / ${walkingGoal.toStringAsFixed(1)} km'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRecommendationItem(
                'Try adding 10 more minutes of walking to reach your daily goal',
                Icons.directions_walk),
            _buildRecommendationItem(
                'Consider plant-based options for one meal to reduce carbon footprint',
                Icons.restaurant),
            _buildRecommendationItem(
                'You\'re close to your weekly exercise target! Keep going!',
                Icons.emoji_events),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing:
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildImpactItem(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Text(value,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green)),
    );
  }

  Widget _buildProgressBar(String label, double progress, String value) {
    // Clamp progress between 0.0 and 1.0
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: clampedProgress,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ],
    );
  }

  static Widget _buildRecommendationItem(String text, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }
}
