//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=Mfa3u3naQew, https://www.youtube.com/watch?v=PBxbWZZTG2Q

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/password_checker.dart';
import 'package:test_app/pages/auth/email_validation.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/utils/constants/text_strings.dart';

//RegisterPage class declaration
class RegisterPage extends StatefulWidget {
  final VoidCallback? showLoginPage;
  const RegisterPage({
    super.key,
    required this.title,
    required this.showLoginPage,
  });

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Text Controllers
  //These variables hold the email and password entered by the user
  //Fields include email, username, password, and password confirmation
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  //This controller is used to test the new password strength
  bool _isStrong = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  //This function adds the user information (email, username)
  Future addUserDetails(String newEmail, String newUsername) async {
    final user = <String, String>{"email": newEmail, "username": newUsername};
    FirebaseFirestore.instance
        .collection("users")
        .doc(newEmail)
        .set(user)
        .onError((e, _) => print(
              "An error occurred: $e",
            ));
  }

  //
  Future checkEmailVerified() async {
    //
  }

  //This function confirms the new account and sends it to the database
  Future signUp() async {
    //Before attempting to confirm the account, we check that...
    //    1.) The password text fields match
    //    2.) The password meets the strong password criteria
    bool matchNewPassword = passwordConfirmed();
    if (matchNewPassword) {
      if (_isStrong) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          if (FirebaseAuth.instance.currentUser != null) {
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => const EmailVerificationScreen()));
          }
        } on FirebaseAuthException catch (e) {
          if (_emailController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('No Login Credentials Found!'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(e.message.toString()),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password not strong enough.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Passwords must match.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    //Add user details to the database (email, username)
    addUserDetails(
      _emailController.text.trim(),
      _usernameController.text.trim(),
    );
  }

  //This function confirms the password
  // confirmation is the same as the given password
  bool passwordConfirmed() {
    if (_passwordController.text.trim() != _confirmController.text.trim()) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.info,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Hello There!
                Text(
                  'Hello There!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
                const Text(
                  AppTexts.signupTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),

                //Email Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Email',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                //Username Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Username',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                //Password Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //Password Confirmation Textfield
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    obscureText: true,
                    controller: _confirmController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: 'Confirm Password',
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //Password Strength Indicator Text
                AnimatedBuilder(
                  animation: _passwordController,
                  builder: (context, child) {
                    final password = _passwordController.text;
                    return PasswordStrengthChecker(
                      password: password,
                      onStrengthChanged: (bool value) {
                        setState(() {
                          _isStrong = value;
                        });
                      },
                    );
                  },
                ),

                //Sign-In Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                //Sign-Up Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        ' Sign in!',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
