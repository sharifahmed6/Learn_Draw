import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthEmailChanged extends AuthEvent {
  final String email;
  const AuthEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  const AuthPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class AuthNameChanged extends AuthEvent {
  final String name;
  const AuthNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class AuthCountryChanged extends AuthEvent {
  final String country;
  const AuthCountryChanged(this.country);

  @override
  List<Object> get props => [country];
}

class AuthCityChanged extends AuthEvent {
  final String city;
  const AuthCityChanged(this.city);

  @override
  List<Object> get props => [city];
}

class AuthMobileNumberChanged extends AuthEvent {
  final String mobileNumber;
  const AuthMobileNumberChanged(this.mobileNumber);

  @override
  List<Object> get props => [mobileNumber];
}

class AuthZipCodeChanged extends AuthEvent {
  final String zipCode;
  const AuthZipCodeChanged(this.zipCode);

  @override
  List<Object> get props => [zipCode];
}

class AuthLoginSubmitted extends AuthEvent {}

class AuthSignupSubmitted extends AuthEvent {}

class AuthCheckStatus extends AuthEvent {}

class AuthFormReset extends AuthEvent {}

class AuthLogoutRequested extends AuthEvent {}

class AuthEmailVerificationCodeReceived extends AuthEvent {
  final String code;

  const AuthEmailVerificationCodeReceived(this.code);
}