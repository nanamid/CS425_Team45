//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/pages/home_page.dart';

void main() async {
  //Initialize the Hive
  await Hive.initFlutter();

  //Open a Box
  var box = await Hive.openBox('mybox');

  //Run the App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
