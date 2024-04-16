//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=Mfa3u3naQew

import 'package:flutter/material.dart';
import 'package:test_app/pages/auth/login_page.dart';
import 'package:test_app/pages/auth/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //Show Login page first
  bool showLoginPage = true;

  //This function toggles between the login and registration pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  //The page shows the designated page depending
  // on the value togglePages returns
  // True = show the registration page
  // False = show the login page
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(title: 'Login Page', showRegisterPage: togglePages);
    } else {
      return RegisterPage(title: 'Register Page', showLoginPage: togglePages);
    }
  }
}
