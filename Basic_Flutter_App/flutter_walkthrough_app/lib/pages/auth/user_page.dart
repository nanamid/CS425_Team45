//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

//This is an adaptation of the above Flutter Tutorial to create a
// landing page for a successful login (that is not the tasks page,
// as seen in the login solo demo)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/auth/auth_page.dart';
import 'package:test_app/pages/auth/verification_page.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return VerifPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
