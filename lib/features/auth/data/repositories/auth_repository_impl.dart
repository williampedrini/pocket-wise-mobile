import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<User> signInWithGoogle() async {
    return await dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await dataSource.signOut();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await dataSource.getCurrentUser();
  }
}
