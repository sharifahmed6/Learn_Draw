import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../widgets/country_picker_widget.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4), // Match app theme
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.deepPurple, size: 20),
              onPressed: () {
                context.read<AuthBloc>().add(AuthFormReset());
                Navigator.of(context).pop();
              },
              tooltip: 'Back',
            ),
          ),
        ),
      ),
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            context.read<AuthBloc>().add(AuthFormReset());
          }
        },
        child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.error && state.errorMessage != null) {
            ToastUtils.showTopMessage(context, state.errorMessage!, isError: true);
          } else if (state.status == AuthStatus.signupSuccess) {
            ToastUtils.showTopMessage(context, 'Signup successful! Please verify your email or login.', isError: false);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/signup_cartoon.png', height: 150),
                  const SizedBox(height: 32),
                  TextFormField(
                    initialValue: state.name,
                    onChanged: (value) => context.read<AuthBloc>().add(AuthNameChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.email,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context.read<AuthBloc>().add(AuthEmailChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CountryPickerWidget(
                    initialCountry: state.country,
                    onCountryChanged: (value) {
                      context.read<AuthBloc>().add(AuthCountryChanged(value));
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.city,
                    onChanged: (value) => context.read<AuthBloc>().add(AuthCityChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'City',
                      prefixIcon: const Icon(Icons.location_city),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.mobileNumber,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) => context.read<AuthBloc>().add(AuthMobileNumberChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.zipCode,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => context.read<AuthBloc>().add(AuthZipCodeChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'Zip Code',
                      prefixIcon: const Icon(Icons.local_post_office),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: state.password,
                    obscureText: true,
                    onChanged: (value) => context.read<AuthBloc>().add(AuthPasswordChanged(value)),
                    decoration: InputDecoration(
                      labelText: 'Password *',
                      prefixIcon: const Icon(Icons.vpn_key),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (state.status == AuthStatus.loading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthSignupSubmitted());
                      },
                      child: const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthFormReset());
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}
