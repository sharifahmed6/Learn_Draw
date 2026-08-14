enum ForgotPasswordStatus { initial, loading, otpSent, otpVerified, success, error }

class ForgotPasswordState {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  final ForgotPasswordStatus status;
  final String? errorMessage;

  ForgotPasswordState({
    this.email = '',
    this.otp = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    String? email,
    String? otp,
    String? newPassword,
    String? confirmPassword,
    ForgotPasswordStatus? status,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage, // We don't ?? here so we can clear errors by passing null
    );
  }
}
