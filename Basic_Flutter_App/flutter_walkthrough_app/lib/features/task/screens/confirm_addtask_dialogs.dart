import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/confirm_dialog.dart';

Future<dynamic> confirmSaveTaskDialog(BuildContext context) {
  return confirmDialog(context,
      prompt: "Are you sure you want to create a new task?");
}

Future<dynamic> confirmCancelTaskDialog(BuildContext context) {
  return confirmDialog(context,
      prompt: "Are you sure you want to cancel adding a new task?");
}
