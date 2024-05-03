//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s, https://www.youtube.com/watch?v=FnXg0NK6hb8

//This is an adaptation of the above Flutter Tutorial to create a
// landing page for a successful login (that is not the tasks page,
// as seen in the login solo demo)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/utils/constants/colors.dart';
import 'package:test_app/pages/auth/email_validation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Firestore Variables
  final String? currentUser = FirebaseAuth.instance.currentUser?.email;
  final CollectionReference firestoreInstance =
      FirebaseFirestore.instance.collection("users");
  bool isEmailVerified = false;
  Timer? timer;
  String currentUsername = '';
  String currentEmail = '';

  checkEmailVerified() async {
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (!isEmailVerified) {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (ctx) => const EmailVerificationScreen()));
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content:
                Text("Your email is verified!", style: TextStyle(fontSize: 16)),
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

  void loadUserData() async {
    await firestoreInstance.doc(currentUser).get().then(
      (event) {
        currentUsername = event["username"];
        currentEmail = event["email"];
      },
    );
  }

  // Function for building the account information
  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Username:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(currentUsername, style: TextStyle(fontSize: 20)),
                    Divider(height: 20, thickness: 1),
                    Text("Email:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(currentEmail, style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: checkEmailVerified,
                  child: Text("Email Check", style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () {
                    //loadUserData();
                    Navigator.of(context).pop();
                  },
                  child: Text("Close", style: TextStyle(fontSize: 16)),
                )
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  // This spot was for a function that controlled the language options
  // This functionality was not successfully implemented, so it was removed

  // Function for building the dialog for project credits
  GestureDetector buildCreditsDialog(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Made For the UNR Computer Science & Engineering 2024 Senior Project",
                      style:
                          TextStyle(fontSize: 19, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    Divider(height: 20, thickness: 5),
                    SizedBox(height: 15),
                    Text(
                      "Our Team:",
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                    Text("Nanami Duncan \n Stosh Peterson \n Jazz Radaza",
                        style: TextStyle(fontSize: 16)),
                    Divider(height: 20, thickness: 2),
                    SizedBox(height: 15),
                    Text("The Teaching Team:",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic)),
                    Text("Sara Davis \n David Feil-Seifer \n Devrin Lee",
                        style: TextStyle(fontSize: 16)),
                    Divider(height: 20, thickness: 2),
                    SizedBox(height: 15),
                    Text("Our Advisor:",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic)),
                    Text("Erin Keith, CSE Instructor",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    loadUserData();
                    Navigator.of(context).pop();
                  },
                  child: Text("Close", style: TextStyle(fontSize: 16)),
                )
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  // Function for building the short privacy statement
  GestureDetector buildPrivacyPolicyDialog(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(height: 20, thickness: 5),
                    SizedBox(height: 15),
                    Text(
                        "Hi! We're Task Titans, a gamified productivity tool designed to empower students with effective task management and motivational features rooted in habit formation and psychology.",
                        style: TextStyle(fontSize: 15)),
                    SizedBox(height: 10),
                    Text(
                        "In order to provide the best experience, we collect information from you, such as your email for account creation. We also collect analytics data for Firebase Analytics. Analytics data does not contain information that can directly, but it does contain information unique to your device.",
                        style: TextStyle(fontSize: 15)),
                    SizedBox(height: 10),
                    Text(
                        "This information will never be sold or shared publicly. We only use this data for Firebase development to track the app's health.",
                        style: TextStyle(fontSize: 15)),
                    SizedBox(height: 10),
                    Text(
                        "For more information, please contact us at levitatingplasma479@gmail.com",
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    loadUserData();
                    Navigator.of(context).pop();
                  },
                  child: Text("Close", style: TextStyle(fontSize: 16)),
                )
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //checkEmailVerified();
    loadUserData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Welcome to Task Titans!",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: AppColors.primary,
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.purple,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  "General",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            buildAccountOption(context, "Account"),
            SizedBox(height: 100),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.purple,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  "Acknowledgments",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            buildCreditsDialog(context, "Developers"),
            buildPrivacyPolicyDialog(context, "Privacy Statement"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
