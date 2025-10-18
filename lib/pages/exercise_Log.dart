// pages/exercise_log.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercise_entry.dart';
import '../utils/data_manager.dart';
import '../theme/text_styles.dart';
import '../theme/app_colors.dart';

class ExerciseLogPage extends StatefulWidget {
  const ExerciseLogPage({super.key});

  @override
  ExerciseLogPageState createState() => ExerciseLogPageState();
}

class ExerciseLogPageState extends State<ExerciseLogPage> {
  final TextEditingController _exerciseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise Log')),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _exerciseController,
                  decoration: InputDecoration(
                    labelText:
                        'Describe your exercise (e.g., "30 min running")',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addExerciseEntry,
                    ),
                  ),
                  onSubmitted: (_) => _addExerciseEntry(),
                ),
                const SizedBox(height: 10),
                const Text('Describe your exercise in simple English',
                    style: TextStyles.caption),
              ],
            ),
          ),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickAction('30 min walking'),
                _buildQuickAction('1 hour cycling'),
                _buildQuickAction('45 min gym'),
                _buildQuickAction('20 min yoga'),
                _buildQuickAction('15 min running'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Exercise Entries List
          Expanded(
            child: dataManager.isLoading
                ? const Center(child: CircularProgressIndicator())
                : dataManager.exerciseEntries.isEmpty
                    ? const Center(
                        child: Text(
                            'No exercise entries yet. Add your first workout!'))
                    : ListView.builder(
                        itemCount: dataManager.exerciseEntries.length,
                        itemBuilder: (context, index) {
                          final entry = dataManager.exerciseEntries[index];
                          return _buildExerciseEntry(entry);
                        },
                      ),
          ),

          // Daily Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2))
              ],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Calories Burned Today:',
                    style: TextStyles.heading6),
                Text('${dataManager.totalCaloriesBurnedToday} kcal',
                    style: TextStyles.heading6
                        .copyWith(color: AppColors.healthNegative)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String text) {
    return ActionChip(
      avatar: const Icon(Icons.bolt, size: 16),
      label: Text(text),
      onPressed: () {
        _exerciseController.text = text;
        _addExerciseEntry();
      },
      backgroundColor: Theme.of(context)
          .colorScheme
          .secondary
          .withAlpha((255 * 0.1).round()),
    );
  }

  void _addExerciseEntry() async {
    if (_exerciseController.text.trim().isNotEmpty) {
      await Provider.of<DataManager>(context, listen: false)
          .addExerciseEntry(_exerciseController.text.trim());
      _exerciseController.clear();
    }
  }

  Widget _buildExerciseEntry(ExerciseEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              AppColors.healthNegative.withAlpha((255 * 0.1).round()),
          child:
              const Icon(Icons.directions_run, color: AppColors.healthNegative),
        ),
        title: Text(entry.description),
        subtitle: Text(
            '${_formatTime(entry.time)} • ${entry.duration} min • ${entry.intensity}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${entry.caloriesBurned} kcal',
                style: TextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.healthNegative)),
            const Text('Burned', style: TextStyles.caption),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
