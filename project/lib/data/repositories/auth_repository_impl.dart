import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<User?> login(String username, String password) async {
    return await localDataSource.login(username, password);
  }

  @override
  Future<void> register(User user, String password) async {
    // Implement registration logic if needed
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }

  @override
  Future<void> resetPassword(String username) async {
    // Implement password reset logic if needed
    throw UnimplementedError();
  }
}
