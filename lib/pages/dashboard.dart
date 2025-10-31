// pages/dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/data_manager.dart';
import '../models/food_entry.dart';
import '../models/exercise_entry.dart';
import '../models/activity_entry.dart';
import 'profile.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Summary
                  _buildSummaryCard(context, dataManager),
                  const SizedBox(height: 24),

                  // Quick Stats Grid
                  _buildStatsGrid(context, dataManager, constraints),
                  const SizedBox(height: 24),

                  // Recent Activities
                  _buildRecentActivities(context, dataManager),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSummaryCard(BuildContext context, DataManager dataManager) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Summary', style: textTheme.titleLarge),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Net Calories:', style: textTheme.bodyMedium),
                Text('${dataManager.netCaloriesToday} kcal',
                    style: textTheme.titleMedium?.copyWith(
                        color: dataManager.netCaloriesToday >= 0
                            ? Colors.orange
                            : Theme.of(context).colorScheme.primary)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Environmental Impact:', style: textTheme.bodyMedium),
                Text(
                    '${dataManager.totalCo2SavedToday.toStringAsFixed(2)} kg CO₂ saved',
                    style: textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, DataManager dataManager,
      BoxConstraints constraints) {
    // Determine the number of columns based on the width.
    // 2 columns for typical phone widths, 4 for wider screens.
    final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;

    final statCards = [
      _buildStatCard(
          context,
          'Calories In',
          dataManager.totalCaloriesToday.toString(),
          'kcal',
          Icons.restaurant_menu,
          Theme.of(context).colorScheme.secondary),
      _buildStatCard(
          context,
          'Calories Out',
          dataManager.totalCaloriesBurnedToday.toString(),
          'kcal',
          Icons.directions_run,
          Colors.orange),
      _buildStatCard(
          context,
          'CO₂ Saved',
          dataManager.totalCo2SavedToday.toStringAsFixed(2),
          'kg',
          Icons.eco,
          Theme.of(context).colorScheme.primary),
      _buildStatCard(context, 'Steps', '8,542', '', Icons.directions_walk,
          Colors.blueGrey), // Placeholder
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1, // Adjust for better card proportions
      ),
      itemCount: statCards.length,
      shrinkWrap: true, // Important for GridView inside a SingleChildScrollView
      physics:
          const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
      itemBuilder: (context, index) => statCards[index],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      String unit, IconData icon, Color color) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: textTheme.headlineSmall),
            if (unit.isNotEmpty) Text(unit, style: textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(title,
                style: textTheme.labelLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context, DataManager dataManager) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activities', style: textTheme.titleLarge),
            const SizedBox(height: 10),
            if (dataManager.recentEntries.isEmpty)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No recent activities logged.",
                    style: TextStyle(color: Colors.grey)),
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
    final iconColor = entry is FoodEntry
        ? Colors.green
        : entry is ExerciseEntry
            ? Colors.orange
            : Colors.blue;

    if (entry is FoodEntry) {
      return _buildGenericActivityItem(entry.description,
          '${entry.calories} kcal', Icons.restaurant, iconColor);
    }
    if (entry is ExerciseEntry) {
      return _buildGenericActivityItem(
          entry.description,
          '${entry.caloriesBurned} kcal burned',
          Icons.directions_run,
          iconColor);
    }
    if (entry is ActivityEntry) {
      return _buildGenericActivityItem(
          entry.description,
          '${entry.co2Saved.toStringAsFixed(2)} kg CO₂ saved',
          Icons.eco,
          iconColor);
    }
    return const SizedBox.shrink();
  }

  Widget _buildGenericActivityItem(
      String title, String value, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing:
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }
}
