// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/data_manager.dart';
import 'pages/dashboard.dart';
import 'pages/food_log.dart';
import 'pages/exercise_log.dart';
import 'pages/activities_log.dart';
import 'pages/insights.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DataManager(),
      child: const HealthEcoTracker(),
    ),
  );
}

class HealthEcoTracker extends StatelessWidget {
  const HealthEcoTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health & Eco Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Or control with a setting
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  MainNavigationState createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const FoodLogPage(),
    const ExerciseLogPage(),
    const ActivitiesLogPage(),
    const InsightsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Food'),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_run), label: 'Exercise'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement), label: 'Activities'),
          BottomNavigationBarItem(
              icon: Icon(Icons.insights), label: 'Insights'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
