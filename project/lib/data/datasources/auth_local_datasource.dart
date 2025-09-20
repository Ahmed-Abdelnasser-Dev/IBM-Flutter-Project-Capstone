import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';

class AuthLocalDataSource {
  final String defaultUsername = 'testuser';
  final String defaultPassword = 'password123';

  Future<User?> login(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (username == defaultUsername && password == defaultPassword) {
      final user = User(
        name: 'Test User',
        username: 'testuser',
        age: 25,
        country: 'United States',
      );
      await prefs.setString('name', user.name);
      await prefs.setString('username', user.username);
      await prefs.setDouble('age', user.age.toDouble());
      await prefs.setString('country', user.country);
      return user;
    } else {
      await prefs.clear();
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
