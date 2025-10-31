import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_tracker_app/main.dart';
import 'package:health_tracker_app/models/user.dart';
import 'package:health_tracker_app/pages/login_page.dart';
import 'package:health_tracker_app/utils/data_manager.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Update DataManager with the current user state
        final dataManager = Provider.of<DataManager>(context, listen: false);
        dataManager.updateUser(snapshot.data);

        // User is not signed in
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        // Render your application if authenticated
        return const MainNavigation();
      },
    );
  }
}
