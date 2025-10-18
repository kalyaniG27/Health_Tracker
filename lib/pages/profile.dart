// pages/profile.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/data_manager.dart';
import '../models/user_profile.dart';
import '../theme/text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    final userProfile = dataManager.userProfile;
    final settings = dataManager.appSettings;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile
            _buildUserProfile(context, userProfile),
            const SizedBox(height: 20),

            // Goals Section
            _buildGoalsSection(context, userProfile),
            const SizedBox(height: 20),

            // Settings
            _buildSettingsSection(context, settings, dataManager),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, UserProfile? profile) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.person, size: 40, color: Colors.green),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.name ?? 'Welcome!',
                    style: TextStyles.heading5,
                  ),
                  const Text('Health & Eco Enthusiast',
                      style: TextStyles.bodySmall),
                  const SizedBox(height: 5),
                  const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                      SizedBox(width: 5),
                      Text('15 Day Streak', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // TODO: Navigate to an edit profile page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection(BuildContext context, UserProfile? profile) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('My Goals', style: TextStyles.heading5),
            const SizedBox(height: 10),
            _buildGoalItem('Daily Calorie Intake',
                '${profile?.goals['dailyCalories'] ?? 'N/A'} kcal'),
            _buildGoalItem('Daily Exercise',
                '${profile?.goals['dailyExercise'] ?? 'N/A'} minutes'),
            _buildGoalItem('Daily Walking',
                '${profile?.goals['dailyWalking'] ?? 'N/A'} km'),
            _buildGoalItem('Weekly CO₂ Reduction',
                '${profile?.goals['weeklyCO2Reduction'] ?? 'N/A'} kg'),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context,
      Map<String, dynamic> settings, DataManager dataManager) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyles.heading5),
            const SizedBox(height: 10),
            _buildSettingItem('Notifications', Icons.notifications,
                settings['notifications'] ?? true, (val) {
              dataManager.updateSetting('notifications', val);
            }),
            _buildSettingItem(
                'Dark Mode', Icons.dark_mode, settings['darkMode'] ?? false,
                (val) {
              dataManager.updateSetting('darkMode', val);
            }),
            _buildSettingItem('Health Sync', Icons.fitness_center,
                settings['healthSync'] ?? true, (val) {
              dataManager.updateSetting('healthSync', val);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalItem(String goal, String target) {
    return ListTile(
      leading: const Icon(Icons.flag, color: Colors.green),
      title: Text(goal),
      trailing:
          Text(target, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSettingItem(
      String title, IconData icon, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.green),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
