//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s, https://www.youtube.com/watch?v=rHIFJo4IbOE

//This is an adaptation of the above Flutter Tutorial to create a
// landing page for a successful login (that is not the tasks page,
// as seen in the login solo demo)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:color_blindness/color_blindness.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Variables
  String selectedThemeColor = "";
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
                SettingsTile(
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
        ));
  }
}


/*
Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Colorblindness Modes",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 10,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Button1"),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 10,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Button2"),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 10,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Button1"),
                    ),
                  ),
                ),
                //
              ],
            ),
          ),
          MaterialButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Sign Out'),
          ),
        ],
      ),
*/