import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> loginWithEmailPassword({required String email, required String password});
  Future<User> signupWithEmailPassword({
    required String email,
    required String password,
    required String name,
    required String country,
    String? city,
    String? mobileNumber,
    String? zipCode,
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> verifyPasswordResetOtp(String email, String otp);
  Future<void> updatePassword(String newPassword);
}
