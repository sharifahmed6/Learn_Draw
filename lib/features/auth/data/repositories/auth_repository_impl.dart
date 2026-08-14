import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> loginWithEmailPassword({required String email, required String password}) async {
    return await remoteDataSource.loginWithEmailPassword(email, password);
  }

  @override
  Future<User> signupWithEmailPassword({
    required String email, 
    required String password,
    required String name,
    required String country,
    String? city,
    String? mobileNumber,
    String? zipCode,
  }) async {
    final model = await remoteDataSource.signupWithEmailPassword(
      email: email, 
      password: password,
      name: name,
      country: country,
      city: city,
      mobileNumber: mobileNumber,
      zipCode: zipCode,
    );
    return User(id: model.id, email: model.email);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<User?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }
  @override
  Future<void> sendPasswordResetEmail(String email) async {
    return await remoteDataSource.sendPasswordResetEmail(email);
  }

  @override
  Future<void> verifyPasswordResetOtp(String email, String otp) async {
    return await remoteDataSource.verifyPasswordResetOtp(email, otp);
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    return await remoteDataSource.updatePassword(newPassword);
  }
}
