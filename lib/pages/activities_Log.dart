// pages/activities_log.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/activity_entry.dart';
import '../utils/data_manager.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class ActivitiesLogPage extends StatefulWidget {
  const ActivitiesLogPage({super.key});

  @override
  ActivitiesLogPageState createState() => ActivitiesLogPageState();
}

class ActivitiesLogPageState extends State<ActivitiesLogPage> {
  final TextEditingController _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Activities')),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _activityController,
                  decoration: InputDecoration(
                    labelText:
                        'Describe your activity (e.g., "walked to work")',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addActivityEntry,
                    ),
                  ),
                  onSubmitted: (_) => _addActivityEntry(),
                ),
                const SizedBox(height: 10),
                const Text('Describe your daily activities in simple English',
                    style: TextStyles.caption),
              ],
            ),
          ),

          // Environmental Impact Info
          _buildEnvironmentalInfo(),

          const SizedBox(height: 20),

          // Activity Entries List
          Expanded(
            child: dataManager.isLoading
                ? const Center(child: CircularProgressIndicator())
                : dataManager.activityEntries.isEmpty
                    ? const Center(
                        child: Text(
                            'No activity entries yet. Add your first activity!'))
                    : ListView.builder(
                        itemCount: dataManager.activityEntries.length,
                        itemBuilder: (context, index) {
                          final entry = dataManager.activityEntries[index];
                          return _buildActivityEntry(entry);
                        },
                      ),
          ),

          // Environmental Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.1).round()),
                    blurRadius: 4,
                    offset: const Offset(0, -2))
              ],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('CO₂ Saved Today:', style: TextStyles.heading6),
                    Text(
                        '${dataManager.totalCo2SavedToday.toStringAsFixed(2)} kg',
                        style: TextStyles.heading6
                            .copyWith(color: AppColors.ecoPositive)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.ecoPositive.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.eco, color: AppColors.ecoPositive),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Walking instead of driving saves approximately 0.2 kg CO₂ per km',
              style: TextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  void _addActivityEntry() async {
    if (_activityController.text.trim().isNotEmpty) {
      await Provider.of<DataManager>(context, listen: false)
          .addActivityEntry(_activityController.text.trim());
      _activityController.clear();
    }
  }

  Widget _buildActivityEntry(ActivityEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.ecoPositive.withAlpha((255 * 0.1).round()),
          child:
              const Icon(Icons.directions_walk, color: AppColors.ecoPositive),
        ),
        title: Text(entry.description),
        subtitle: Text(
            '${_formatTime(entry.time)} • ${entry.distance.toStringAsFixed(1)} km'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${entry.co2Saved.toStringAsFixed(2)} kg',
                style: TextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.ecoPositive)),
            const Text('CO₂ saved', style: TextStyles.caption),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
