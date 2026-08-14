import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../domain/usecases/login_usecase.dart';
import '../data/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase login;
  final SignupUsecase signup;
  final LogoutUsecase logout;
  final GetCurrentUserUsecase getCurrentUser;

  AuthBloc({
    required this.login,
    required this.signup,
    required this.logout,
    required this.getCurrentUser,
  }) : super(const AuthState()) {
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthNameChanged>(_onNameChanged);
    on<AuthCountryChanged>(_onCountryChanged);
    on<AuthCityChanged>(_onCityChanged);
    on<AuthMobileNumberChanged>(_onMobileNumberChanged);
    on<AuthZipCodeChanged>(_onZipCodeChanged);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthSignupSubmitted>(_onSignupSubmitted);
    on<AuthCheckStatus>(_onCheckStatus);
    on<AuthFormReset>(_onFormReset);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthEmailVerificationCodeReceived>(
      _onEmailVerificationCodeReceived,
    );
  }
  Future<void> _onEmailVerificationCodeReceived(
      AuthEmailVerificationCodeReceived event,
      Emitter<AuthState> emit,
      ) async {
    try {
      final supabase = sb.Supabase.instance.client;
      await supabase.auth.exchangeCodeForSession(
        event.code,
      );

      final user = supabase.auth.currentUser;

      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated, 
          user: UserModel.fromSupabaseUser(user),
          errorMessage: null,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error, 
        errorMessage: e.toString(),
      ));
    }
  }
  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onFormReset(AuthFormReset event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      email: '',
      password: '',
      name: '',
      country: '',
      city: '',
      mobileNumber: '',
      zipCode: '',
      errorMessage: null,
      status: AuthStatus.initial,
    ));
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onNameChanged(AuthNameChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onCountryChanged(AuthCountryChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(country: event.country));
  }

  void _onCityChanged(AuthCityChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(city: event.city));
  }

  void _onMobileNumberChanged(AuthMobileNumberChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(mobileNumber: event.mobileNumber));
  }

  void _onZipCodeChanged(AuthZipCodeChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(zipCode: event.zipCode));
  }

  Future<void> _onLoginSubmitted(AuthLoginSubmitted event, Emitter<AuthState> emit) async {
    if (state.email.trim().isEmpty || state.password.trim().isEmpty) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Please enter both email and password.'));
      // Reset status so the error can be shown again if clicked multiple times
      emit(state.copyWith(status: AuthStatus.initial, errorMessage: null));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await login(email: state.email, password: state.password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onSignupSubmitted(AuthSignupSubmitted event, Emitter<AuthState> emit) async {
    if (state.name.trim().isEmpty || state.email.trim().isEmpty || state.country.trim().isEmpty || state.password.trim().isEmpty) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Please enter your Name, Email, Country, and Password to continue.'));
      emit(state.copyWith(status: AuthStatus.initial, errorMessage: null));
      return;
    }

    if (state.password.trim().length < 6) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: 'Password must be at least 6 characters long.'));
      emit(state.copyWith(status: AuthStatus.initial, errorMessage: null));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await signup(
        email: state.email, 
        password: state.password,
        name: state.name,
        country: state.country,
        city: state.city,
        mobileNumber: state.mobileNumber,
        zipCode: state.zipCode,
      );
      emit(state.copyWith(status: AuthStatus.signupSuccess, user: user, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onCheckStatus(AuthCheckStatus event, Emitter<AuthState> emit) async {
    try {
      final user = await getCurrentUser();
      if (user != null) {
        emit(state.copyWith(status: AuthStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      }
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
