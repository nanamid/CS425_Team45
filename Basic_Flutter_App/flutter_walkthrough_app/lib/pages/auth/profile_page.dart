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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Firestore Variables
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final String? currentUser = FirebaseAuth.instance.currentUser?.email;
  final CollectionReference firestoreInstance =
      FirebaseFirestore.instance.collection("users");

  //TEST VARIABLES
  bool darkMode = false;
  String currentUsername = '';
  String currentEmail = '';
  //TEST VARIABLES

  // Placeholder function
  onChangeFunction1(bool newValue1) {
    setState(() {
      darkMode = newValue1;
    });
  }

  // Function for retrieving the username and email of the current user
  Future<Map<String, dynamic>> firebaseGet(String docID) async {
    DocumentSnapshot docSnap =
        await firebaseFirestore.collection("users").doc(docID).get();
    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
    return data;
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Username:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(currentUsername),
                    Divider(height: 20, thickness: 1),
                    Text("Email:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    Text(currentEmail),
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

  GestureDetector buildLanguageOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("English", style: TextStyle(fontSize: 20)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Spanish", style: TextStyle(fontSize: 20)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("French", style: TextStyle(fontSize: 20)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Chinese", style: TextStyle(fontSize: 20)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text("Hindi", style: TextStyle(fontSize: 20)),
                    ),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to Task Titans!",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
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
            buildNotificationOption("Dark Mode", darkMode, onChangeFunction1),
            SizedBox(height: 100),
            Row(
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  color: Colors.purple,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text(
                  "Credits",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            //
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


/*
  // Variables
  double selectedThemeColor = 0.0;
  double userTextSize = 0.5;
  ColorBlindnessType typeSelected = ColorBlindnessType.none;
  int seed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, USER!"),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('General'),
            tiles: [
              SettingsTile.navigation(
                leading: Icon(Icons.person),
                title: Text('Account'),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: Text('Dark Mode'),
                leading: Icon(Icons.dark_mode),
                onToggle: (bool value) {},
                initialValue: false,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        //
        child: const Icon(Icons.logout),
      ),
    );
  }
*/