import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc({required this.authRepository}) : super(ForgotPasswordState()) {
    on<ForgotPasswordEmailChanged>(_onEmailChanged);
    on<ForgotPasswordOtpChanged>(_onOtpChanged);
    on<ForgotPasswordNewPasswordChanged>(_onNewPasswordChanged);
    on<ForgotPasswordConfirmPasswordChanged>(_onConfirmPasswordChanged);
    
    on<ForgotPasswordSendOtpSubmitted>(_onSendOtpSubmitted);
    on<ForgotPasswordVerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<ForgotPasswordResetSubmitted>(_onResetSubmitted);
  }

  void _onEmailChanged(ForgotPasswordEmailChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onOtpChanged(ForgotPasswordOtpChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(
      otp: event.otp,
      status: state.status == ForgotPasswordStatus.error ? ForgotPasswordStatus.otpSent : state.status,
      errorMessage: null,
    ));
  }

  void _onNewPasswordChanged(ForgotPasswordNewPasswordChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(newPassword: event.password));
  }

  void _onConfirmPasswordChanged(ForgotPasswordConfirmPasswordChanged event, Emitter<ForgotPasswordState> emit) {
    emit(state.copyWith(confirmPassword: event.password));
  }

  Future<void> _onSendOtpSubmitted(ForgotPasswordSendOtpSubmitted event, Emitter<ForgotPasswordState> emit) async {
    if (state.email.trim().isEmpty) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: 'Please enter your email.'));
      emit(state.copyWith(status: ForgotPasswordStatus.initial, errorMessage: null));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await authRepository.sendPasswordResetEmail(state.email);
      emit(state.copyWith(status: ForgotPasswordStatus.otpSent));
    } catch (e) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: ForgotPasswordStatus.initial, errorMessage: null));
    }
  }

  Future<void> _onVerifyOtpSubmitted(ForgotPasswordVerifyOtpSubmitted event, Emitter<ForgotPasswordState> emit) async {
    if (state.otp.trim().length < 6) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: 'Please enter the 6-digit OTP.'));
      // No reset here, so Pinput stays in error state until user types again
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await authRepository.verifyPasswordResetOtp(state.email, state.otp);
      emit(state.copyWith(status: ForgotPasswordStatus.otpVerified));
    } catch (e) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: ForgotPasswordStatus.otpSent, errorMessage: null));
    }
  }

  Future<void> _onResetSubmitted(ForgotPasswordResetSubmitted event, Emitter<ForgotPasswordState> emit) async {
    if (state.newPassword.isEmpty || state.confirmPassword.isEmpty) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: 'Please enter both passwords.'));
      emit(state.copyWith(status: ForgotPasswordStatus.otpVerified, errorMessage: null));
      return;
    }

    if (state.newPassword != state.confirmPassword) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: 'Passwords do not match.'));
      emit(state.copyWith(status: ForgotPasswordStatus.otpVerified, errorMessage: null));
      return;
    }
    
    if (state.newPassword.length < 6) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: 'Password must be at least 6 characters.'));
      emit(state.copyWith(status: ForgotPasswordStatus.otpVerified, errorMessage: null));
      return;
    }

    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await authRepository.updatePassword(state.newPassword);
      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ForgotPasswordStatus.error, errorMessage: e.toString()));
      emit(state.copyWith(status: ForgotPasswordStatus.otpVerified, errorMessage: null));
    }
  }
}
