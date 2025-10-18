import '../models/user.dart';

class AuthService {
  static Future<bool> signUp(String email, String password, String name) async {
    // Simulate sign-up process
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    // In a real app, you would check if the email already exists in your database
    // For this example, we'll just return true if the email is not 'existing@email.com'
    if (email == 'existing@email.com') {
      return false; // Simulate email already exists
    }

    return true; // Simulate successful sign-up
  }

  static Future<User?> getCurrentUser() async {
    // Simulate fetching the current user
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    // For this example, we'll return a mock user
    return User(
      id: '123',
      email: 'test@example.com',
      name: 'Test User',
    );
  }

  static Future<bool> signIn(String email, String password) async {
    // Simulate sign-in process
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay

    // In a real app, you would authenticate the user against your database
    // For this example, we'll just return true for any email/password
    return true; // Simulate successful sign-in
  }

  static Future<void> signOut() async {
    // Simulate sign-out process
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay

    // In a real app, you would clear any stored user data
    print('User signed out');
  }
}
