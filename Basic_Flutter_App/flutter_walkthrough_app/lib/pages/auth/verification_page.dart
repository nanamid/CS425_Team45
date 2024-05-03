//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=Mfa3u3naQew

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/auth/email_validation.dart';
import 'package:test_app/pages/auth/profile_page.dart';

class VerifPage extends StatefulWidget {
  const VerifPage({super.key});

  @override
  State<VerifPage> createState() => _VerifPageState();
}

class _VerifPageState extends State<VerifPage> {
  //Show Login page first
  bool isEmailVerified = false;

  //This function toggles between the login and registration pages
  bool checkEmailVerification() {
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    return isEmailVerified;
  }

  //The page shows the designated page depending
  // on the value togglePages returns
  // True = show the registration page
  // False = show the login page
  @override
  Widget build(BuildContext context) {
    if (checkEmailVerification() == true) {
      return ProfilePage();
    } else {
      return EmailVerificationScreen();
    }
  }
}
