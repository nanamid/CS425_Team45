//WEB: https://github.com/flutter-devs/email_verification_using_firebase/blob/master/lib/views/auth/email_verification_page.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/auth/verification_page.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/text_strings.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: isEmailVerified
            ? VerifPage()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 35),
                    const SizedBox(height: 30),
                    const SizedBox(height: 110),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: Text(
                          'We have sent you an email at ${FirebaseAuth.instance.currentUser?.email}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: Text(
                          'Verifying email...',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: Text(
                          'Please follow the instructions in the email',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 90),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: ElevatedButton(
                        child: const Text(AppTexts.resendEmail),
                        onPressed: () {
                          try {
                            FirebaseAuth.instance.currentUser
                                ?.sendEmailVerification();
                          } catch (e) {
                            debugPrint('$e');
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Center(
                        child: Text(
                          AppTexts.emailNotReceivedMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
