//CODE FROM Mitch Koko (YouTube)
//WEB: https://www.youtube.com/watch?v=HQ_ytw58tC4&t=1s
// Modified to add user confirmation

import 'package:flutter/material.dart';
import 'package:test_app/utils/my_buttons.dart';
import 'package:test_app/utils/confirm_dialog.dart';

/// Shows a dialog with a textbox
/// controller
class DialogBox extends StatelessWidget {
  /// Text controller
  final TextEditingController controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  /// Whether to ask confirmation on save
  bool confirmSave;

  /// Whether to ask confirmation on save
  bool confirmCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    this.confirmSave = false,
    this.confirmCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                      MyButton(
                          text: "Save",
                          onPressed: () async {
                            bool? confirmation;
                            if (confirmSave) {
                              confirmation = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ConfirmDialog(
                                        content:
                                            'Are you sure you want to save?');
                                  });
                              if (confirmation == true) {
                                onSave();
                              }
                            } else {
                              onSave();
                            }
                          }),

                      //TEXT BOX
                      const SizedBox(width: 8),

                      //CANCEL
                      MyButton(
                          text: "Cancel",
                          onPressed: () async {
                            bool? confirmation;
                            if (confirmCancel) {
                              confirmation = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ConfirmDialog(
                                        content:
                                            'Are you sure you want to cancel?');
                                  });
                              if (confirmation == true) {
                                onCancel();
                              }
                            } else {
                              onCancel();
                            }
                          }),
                    ],
                  )
                ])));
  }
}
