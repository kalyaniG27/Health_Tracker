// pages/dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/data_manager.dart';
import '../models/food_entry.dart';
import '../models/exercise_entry.dart';
import '../models/activity_entry.dart';
import 'profile.dart';
import '../theme/text_styles.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Dashboard'),
        actions: [
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              })
        ],
      ),
      body: Consumer<DataManager>(builder: (context, dataManager, child) {
        if (dataManager.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Summary
              _buildSummaryCard(context, dataManager),
              const SizedBox(height: 20),

              // Quick Stats
              Row(
                children: [
                  Expanded(
                      child: _buildStatCard(
                          'Calories In',
                          dataManager.totalCaloriesToday.toString(),
                          'kcal',
                          Icons.restaurant,
                          Theme.of(context).colorScheme.secondary)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildStatCard(
                          'Calories Out',
                          dataManager.totalCaloriesBurnedToday.toString(),
                          'kcal',
                          Icons.directions_run,
                          Colors.orange)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _buildStatCard(
                          'CO₂ Saved',
                          dataManager.totalCo2SavedToday.toStringAsFixed(2),
                          'kg',
                          Icons.eco,
                          Theme.of(context).primaryColor)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _buildStatCard(
                          'Steps',
                          '8,542',
                          '',
                          Icons.directions_walk,
                          Colors.blueGrey)), // Placeholder
                ],
              ),
              const SizedBox(height: 20),

              // Recent Activities
              _buildRecentActivities(context, dataManager),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCard(BuildContext context, DataManager dataManager) {
    return Card(
      elevation: 4,
      color: Theme.of(context).primaryColor.withAlpha((255 * 0.1).round()),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Summary', style: TextStyles.heading5),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Net Calories:', style: TextStyles.bodyMedium),
                Text('${dataManager.netCaloriesToday} kcal',
                    style: TextStyles.heading6.copyWith(
                        color: dataManager.netCaloriesToday >= 0
                            ? Colors.orange
                            : Theme.of(context).primaryColor)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Environmental Impact:',
                    style: TextStyles.bodyMedium),
                Text(
                    '${dataManager.totalCo2SavedToday.toStringAsFixed(2)} kg CO₂ saved',
                    style: TextStyles.heading6.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String unit, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 5),
            Text(value, style: TextStyles.heading5),
            Text(unit, style: TextStyles.caption),
            Text(title,
                style:
                    TextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, DataManager dataManager) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Recent Activities', style: TextStyles.heading5),
            const SizedBox(height: 10),
            if (dataManager.recentEntries.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No recent activities logged.",
                    style: TextStyles.bodyMedium),
              ))
            else
              ...dataManager.recentEntries
                  .map((entry) => _buildActivityItem(entry)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(dynamic entry) {
    if (entry is FoodEntry) {
      return _buildGenericActivityItem(entry.mealType, entry.description,
          '${entry.calories} kcal', Icons.restaurant);
    }
    if (entry is ExerciseEntry) {
      return _buildGenericActivityItem(entry.intensity, entry.description,
          '${entry.caloriesBurned} kcal burned', Icons.directions_run);
    }
    if (entry is ActivityEntry) {
      return _buildGenericActivityItem(entry.transportMode, entry.description,
          '${entry.co2Saved.toStringAsFixed(2)} kg CO₂ saved', Icons.eco);
    }
    return const SizedBox.shrink();
  }

  Widget _buildGenericActivityItem(
      String title, String subtitle, String value, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.shade100,
        child: Icon(icon, color: Colors.green, size: 20),
      ),
      title: Text(title,
          style: TextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Text(value,
          style: TextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
