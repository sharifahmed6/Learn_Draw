import 'package:equatable/equatable.dart';
import '../domain/entities/user.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error, signupSuccess }

class AuthState extends Equatable {
  final String email;
  final String password;
  final String name;
  final String country;
  final String city;
  final String mobileNumber;
  final String zipCode;
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.email = '',
    this.password = '',
    this.name = '',
    this.country = '',
    this.city = '',
    this.mobileNumber = '',
    this.zipCode = '',
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    String? email,
    String? password,
    String? name,
    String? country,
    String? city,
    String? mobileNumber,
    String? zipCode,
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      country: country ?? this.country,
      city: city ?? this.city,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      zipCode: zipCode ?? this.zipCode,
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        country,
        city,
        mobileNumber,
        zipCode,
        status,
        user,
        errorMessage,
      ];
}
