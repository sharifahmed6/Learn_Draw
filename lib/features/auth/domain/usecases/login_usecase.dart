import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<User> call({required String email, required String password}) async {
    return await repository.loginWithEmailPassword(email: email, password: password);
  }
}

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<User> call({
    required String email, 
    required String password,
    required String name,
    required String country,
    String? city,
    String? mobileNumber,
    String? zipCode,
  }) async {
    return await repository.signupWithEmailPassword(
      email: email, 
      password: password,
      name: name,
      country: country,
      city: city,
      mobileNumber: mobileNumber,
      zipCode: zipCode,
    );
  }
}

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}
