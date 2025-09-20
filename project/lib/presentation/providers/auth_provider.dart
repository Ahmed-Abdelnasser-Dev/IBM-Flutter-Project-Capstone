
import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  User? _user;
  String? _error;
  bool _loading = false;

  AuthProvider({required this.loginUseCase});

  User? get user => _user;
  String? get error => _error;
  bool get loading => _loading;

  Future<void> login(String username, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    final result = await loginUseCase(username, password);
    if (result != null) {
      _user = result;
    } else {
      _error = 'The username or password was incorrect';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> resetPassword(String username) async {
    // TODO: Implement password reset logic
    // For now, just simulate a delay
    await Future.delayed(const Duration(seconds: 1));
    _error = 'Password reset link sent (stub)';
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
