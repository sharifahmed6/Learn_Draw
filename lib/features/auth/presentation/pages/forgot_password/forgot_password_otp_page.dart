import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/utils/toast_utils.dart';
import '../../bloc/forgot_password/forgot_password_bloc.dart';
import '../../bloc/forgot_password/forgot_password_event.dart';
import '../../bloc/forgot_password/forgot_password_state.dart';
import 'forgot_password_reset_page.dart';

class ForgotPasswordOtpPage extends StatelessWidget {
  const ForgotPasswordOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: const Text('Verify OTP', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.error && state.errorMessage != null) {
            ToastUtils.showTopMessage(context, state.errorMessage!, isError: true);
          } else if (state.status == ForgotPasswordStatus.otpVerified) {
            ToastUtils.showTopMessage(context, 'OTP Verified!', isError: false);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ForgotPasswordBloc>(),
                  child: const ForgotPasswordResetPage(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.purple.shade100, blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mark_email_read, size: 80, color: Colors.deepPurple),
                    const SizedBox(height: 16),
                    const Text(
                      'Verify Email',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the 6-digit OTP sent to\n${state.email}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    Pinput(
                      length: 6,
                      forceErrorState: state.status == ForgotPasswordStatus.error,
                      errorText: state.status == ForgotPasswordStatus.error ? state.errorMessage : null,
                      onChanged: (val) {
                        context.read<ForgotPasswordBloc>().add(ForgotPasswordOtpChanged(val));
                      },
                      onCompleted: (val) => context.read<ForgotPasswordBloc>().add(ForgotPasswordVerifyOtpSubmitted()),
                      defaultPinTheme: PinTheme(
                        width: 50,
                        height: 56,
                        textStyle: const TextStyle(fontSize: 22, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple.shade200),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 50,
                        height: 56,
                        textStyle: const TextStyle(fontSize: 22, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: state.status == ForgotPasswordStatus.loading
                            ? null
                            : () => context.read<ForgotPasswordBloc>().add(ForgotPasswordVerifyOtpSubmitted()),
                        child: state.status == ForgotPasswordStatus.loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Verify OTP', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
