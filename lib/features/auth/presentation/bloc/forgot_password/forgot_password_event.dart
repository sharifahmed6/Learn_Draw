abstract class ForgotPasswordEvent {}

class ForgotPasswordEmailChanged extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordEmailChanged(this.email);
}

class ForgotPasswordOtpChanged extends ForgotPasswordEvent {
  final String otp;
  ForgotPasswordOtpChanged(this.otp);
}

class ForgotPasswordNewPasswordChanged extends ForgotPasswordEvent {
  final String password;
  ForgotPasswordNewPasswordChanged(this.password);
}

class ForgotPasswordConfirmPasswordChanged extends ForgotPasswordEvent {
  final String password;
  ForgotPasswordConfirmPasswordChanged(this.password);
}

class ForgotPasswordSendOtpSubmitted extends ForgotPasswordEvent {}

class ForgotPasswordVerifyOtpSubmitted extends ForgotPasswordEvent {}

class ForgotPasswordResetSubmitted extends ForgotPasswordEvent {}
