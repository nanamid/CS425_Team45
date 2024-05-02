//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s, https://www.youtube.com/watch?v=FnXg0NK6hb8

//This is an adaptation of the above Flutter Tutorial to create a
// landing page for a successful login (that is not the tasks page,
// as seen in the login solo demo)

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:settings_ui/settings_ui.dart';  //Looking into this!
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/utils/constants/colors.dart';

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
  String currentUsername = '';
  String currentEmail = '';

  //TEST VARIABLES
  bool darkMode = false;
  //TEST VARIABLES

  // Placeholder function
  onChangeFunction1(bool newValue1) {
    setState(() {
      darkMode = newValue1;
    });
  }

  void loadUserData() async {
    await firestoreInstance.doc(currentUser).get().then(
      (event) {
        currentUsername = event["username"];
        currentEmail = event["email"];
      },
    );
  }

  // Function for building the options in the pop-out dialog under "General"
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
                    Text(currentEmail, style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    //loadUserData();
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
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

  GestureDetector buildLanguageOption(BuildContext context, String title) {
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
                    TextButton(
                      onPressed: () {},
                      child: Text("English", style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {},
                      child: Text("Spanish", style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {},
                      child: Text("French", style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {},
                      child: Text("Chinese", style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {},
                      child: Text("Hindi", style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
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
                  child: Text("Close"),
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

  // Function for building the dialog for project credits
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
                        "In order to provide the best experience, we collect information from you, such as your email for account creation. We also collect analytics data for Firebase Analytics. Analytics data does not contain information that can directly, but it does contain information unique to your device."),
                    SizedBox(height: 10),
                    Text(
                        "This information will never be sold or shared publicly. We only use this data for Firebase development to track the app's health."),
                    SizedBox(height: 10),
                    Text(
                        "For more information, please contact us at levitatingplasma479@gmail.com"),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    loadUserData();
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
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

  // Function for building the switch for settings below "Notifications" block
  Padding buildNotificationOption(
      String title, bool value, Function onChangeMethod) {
    return Padding(
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
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            buildLanguageOption(context, "Languages"),
            //buildNotificationOption("Dark Mode", darkMode, onChangeFunction1),
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
