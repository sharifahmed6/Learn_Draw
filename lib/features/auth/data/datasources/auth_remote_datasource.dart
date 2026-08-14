import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import '../models/user_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailPassword(String email, String password);
  Future<UserModel> signupWithEmailPassword({
    required String email, 
    required String password,
    required String name,
    required String country,
    String? city,
    String? mobileNumber,
    String? zipCode,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> verifyPasswordResetOtp(String email, String otp);
  Future<void> updatePassword(String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  final _logger = Logger();

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<UserModel> loginWithEmailPassword(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(email: email, password: password);
      if (response.session != null && response.user != null) {
        _logger.i('Login successful for user: ${response.user!.id}');
        return UserModel.fromSupabaseUser(response.user!);
      } else {
        throw const ServerException(message: 'Login failed: Unknown error');
      }
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('invalid login credentials') || e.message.toLowerCase().contains('invalid')) {
        _logger.w('Login failed: Invalid credentials for $email');
        throw const ServerException(message: 'Email or password is incorrect.');
      }
      _logger.e('Login failed (AuthException): ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      _logger.e('Login failed (Unknown): $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailPassword({
    required String email, 
    required String password,
    required String name,
    required String country,
    String? city,
    String? mobileNumber,
    String? zipCode,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email.trim(), 
        password: password.trim(),
        emailRedirectTo: 'myapp://auth-callback',
        data: {
          'name': name.trim(),
          'country': country.trim(),
          'city': city?.trim(),
          'mobile_number': mobileNumber?.trim(),
          'zip_code': zipCode?.trim(),
        }
      );
      
      final user = response.user;
      if (user != null) {
        _logger.i('Signup successful. Profile data passed to auth metadata for User ID: ${user.id}');
        
        return UserModel.fromSupabaseUser(user);
      } else {
        _logger.e('Signup failed: Unknown error');
        throw const ServerException(message: 'Signup failed: Unknown error');
      }
    } on AuthException catch (e) {
      _logger.e('Signup error (AuthException): ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      _logger.e('Signup error (Unknown): $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
      _logger.i('Logout successful');
    } catch (e) {
      _logger.e('Logout failed: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = supabaseClient.auth.currentUser;
      if (user != null) {
        _logger.i('Current user fetched: ${user.id}');
        return UserModel.fromSupabaseUser(user);
      }
      _logger.i('No current user found');
      return null;
    } catch (e) {
      _logger.e('Fetch current user failed: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email.trim());
      _logger.i('Password reset email sent to: $email');
    } catch (e) {
      _logger.e('Failed to send password reset email: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> verifyPasswordResetOtp(String email, String otp) async {
    try {
      final response = await supabaseClient.auth.verifyOTP(
        email: email.trim(),
        token: otp.trim(),
        type: OtpType.recovery,
      );
      if (response.session == null) {
        _logger.e('OTP Verification failed: Invalid or expired OTP');
        throw const ServerException(message: 'Invalid or expired OTP');
      }
      _logger.i('OTP Verified successfully for $email');
    } on AuthException catch (e) {
      _logger.e('OTP Verification AuthException: ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      _logger.e('OTP Verification Unknown Error: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    try {
      await supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _logger.i('Password updated successfully');
    } on AuthException catch (e) {
      _logger.e('Update password AuthException: ${e.message}');
      throw ServerException(message: e.message);
    } catch (e) {
      _logger.e('Update password Unknown Error: $e');
      throw ServerException(message: e.toString());
    }
  }
}
