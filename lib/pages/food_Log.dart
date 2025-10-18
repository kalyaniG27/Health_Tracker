// pages/food_log.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_entry.dart';
import '../utils/data_manager.dart';
import '../theme/text_styles.dart';

class FoodLogPage extends StatefulWidget {
  const FoodLogPage({super.key});

  @override
  FoodLogPageState createState() => FoodLogPageState();
}

class FoodLogPageState extends State<FoodLogPage> {
  final TextEditingController _foodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Food Intake')),
      body: Column(
        children: [
          // Input Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _foodController,
                  decoration: InputDecoration(
                    labelText: 'What did you eat? (e.g., "2 eggs and toast")',
                    // Using theme border
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addFoodEntry,
                    ),
                  ),
                  onSubmitted: (_) => _addFoodEntry(),
                ),
                const SizedBox(height: 10),
                const Text('Describe your meal in simple English',
                    style: TextStyles.caption),
              ],
            ),
          ),

          // Food Entries List
          Expanded(
            child: dataManager.isLoading
                ? const Center(child: CircularProgressIndicator())
                : dataManager.foodEntries.isEmpty
                    ? const Center(
                        child:
                            Text('No food entries yet. Add your first meal!'))
                    : ListView.builder(
                        itemCount: dataManager.foodEntries.length,
                        itemBuilder: (context, index) {
                          final entry = dataManager.foodEntries[
                              dataManager.foodEntries.length -
                                  1 -
                                  index]; // Show newest first
                          return _buildFoodEntry(entry);
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
                    color: Colors.black.withAlpha((255 * 0.1).round()),
                    blurRadius: 4,
                    offset: const Offset(0, -2))
              ],
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Calories Today:', style: TextStyles.heading6),
                Text('${dataManager.totalCaloriesToday} kcal',
                    style: TextStyles.heading6
                        .copyWith(color: Theme.of(context).primaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addFoodEntry() async {
    if (_foodController.text.trim().isNotEmpty) {
      // Use the DataManager to add the entry
      await Provider.of<DataManager>(context, listen: false)
          .addFoodEntry(_foodController.text.trim());
      _foodController.clear();
    }
  }

  Widget _buildFoodEntry(FoodEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context)
              .colorScheme
              .secondary
              .withAlpha((255 * 0.1).round()),
          child: Icon(Icons.restaurant,
              color: Theme.of(context).colorScheme.secondary),
        ),
        title: Text(entry.description),
        subtitle: Text(_formatTime(entry.time)),
        trailing: Text('${entry.calories} kcal',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}
