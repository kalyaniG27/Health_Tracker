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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildUserProfile(context, userProfile),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'My Goals', Icons.flag_circle_outlined),
          const SizedBox(height: 8),
          _buildGoalsSection(context, userProfile),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Settings', Icons.settings_outlined),
          const SizedBox(height: 8),
          _buildSettingsSection(context, settings, dataManager),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: TextStyles.heading5),
      ],
    );
  }

  Widget _buildUserProfile(BuildContext context, UserProfile? profile) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.person,
                  size: 40,
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
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
                  const SizedBox(height: 4),
                  Text(
                    'Health & Eco Enthusiast',
                    style: TextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    avatar: const Icon(Icons.emoji_events,
                        color: Colors.amber, size: 18),
                    label: const Text('15 Day Streak'),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    labelStyle: const TextStyle(fontSize: 12),
                    backgroundColor: Colors.amber.shade100,
                  ),
                ],
              ),
            ),
            Tooltip(
              message: 'Edit Profile',
              child: IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                onPressed: () {
                  // TODO: Navigate to an edit profile page
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('Edit profile functionality coming soon!')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsSection(BuildContext context, UserProfile? profile) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildGoalItem(
            context,
            'Daily Calorie Intake',
            '${profile?.goals['dailyCalories'] ?? 'N/A'} kcal',
            Icons.local_fire_department_outlined,
            0.7, // Example progress
          ),
          _buildGoalItem(
            context,
            'Daily Exercise',
            '${profile?.goals['dailyExercise'] ?? 'N/A'} minutes',
            Icons.fitness_center_outlined,
            0.4, // Example progress
          ),
          _buildGoalItem(
            context,
            'Daily Walking',
            '${profile?.goals['dailyWalking'] ?? 'N/A'} km',
            Icons.directions_walk_outlined,
            0.9, // Example progress
          ),
          _buildGoalItem(
            context,
            'Weekly CO₂ Reduction',
            '${profile?.goals['weeklyCO2Reduction'] ?? 'N/A'} kg',
            Icons.eco_outlined,
            0.2, // Example progress
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context,
      Map<String, dynamic> settings, DataManager dataManager) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildSettingItem(
            context,
            'Notifications',
            Icons.notifications_outlined,
            settings['notifications'] ?? true,
            (val) => dataManager.updateSetting('notifications', val),
          ),
          _buildSettingItem(
            context,
            'Dark Mode',
            Icons.dark_mode_outlined,
            settings['darkMode'] ?? false,
            (val) => dataManager.updateSetting('darkMode', val),
          ),
          _buildSettingItem(
            context,
            'Health Sync',
            Icons.sync_outlined,
            settings['healthSync'] ?? true,
            (val) => dataManager.updateSetting('healthSync', val),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(BuildContext context, String goal, String target,
      IconData icon, double progress,
      {bool isLast = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to goal details page
        },
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(goal),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
          trailing: Text(target,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, IconData icon,
      bool value, ValueChanged<bool> onChanged,
      {bool isLast = false}) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Theme.of(context).colorScheme.primary,
    );
  }
}
