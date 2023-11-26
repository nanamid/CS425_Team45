//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s

import 'package:flutter/material.dart';
import 'package:test_app/utils/my_buttons.dart';

class DialogBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.blue[200],
        content: SizedBox(
            height: 120,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Receive User Input
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Add a New Task",
                    ),
                  ),

                  //Button to save or cancel input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //SAVE
                      MyButton(text: "Save", onPressed: onSave),

                      //TEXT BOX
                      const SizedBox(width: 8),

                      //CANCEL
                      MyButton(text: "Cancel", onPressed: onCancel),
                    ],
                  )
                ])));
  }
}
