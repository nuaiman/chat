import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../controller/auth_controller.dart';
import 'auth_phone_view.dart';

class AuthOtpView extends ConsumerStatefulWidget {
  const AuthOtpView({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  ConsumerState<AuthOtpView> createState() => _AuthOtpViewState();
}

class _AuthOtpViewState extends ConsumerState<AuthOtpView> {
  final _otpController = TextEditingController();

  void _onCompleted(String pin) {
    ref.read(authControllerProvider.notifier).updateSession(
          context: context,
          userId: widget.userId,
          secret: pin,
        );
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/background.jpg'),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Bisky Chat',
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 60),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  child: Column(
                    children: [
                      OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceAround,
                        fieldWidth: 45,
                        fieldStyle: FieldStyle.box,
                        otpFieldStyle: OtpFieldStyle(
                          backgroundColor: Colors.white,
                          enabledBorderColor: Colors.white,
                        ),
                        outlineBorderRadius: 15,
                        style:
                            const TextStyle(fontSize: 24, color: Colors.black),
                        onChanged: (pin) {},
                        onCompleted: (pin) => _onCompleted(pin),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minWidth: double.infinity,
                  height: 60,
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  onPressed: isLoading
                      ? () {}
                      : () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const AuthPhoneView(),
                              ),
                              (route) => false);
                        },
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Go Back',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
