import '../entities/user.dart';

abstract class AuthRepository {
  Future<User?> login(String username, String password);
  Future<void> register(User user, String password);
  Future<void> logout();
  Future<void> resetPassword(String username);
}
