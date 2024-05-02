import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/confirm_dialog.dart';

Future<bool?> confirmSaveTaskDialog(BuildContext context) {
  return confirmDialog(context,
      prompt: "Are you sure you want to make these changes?");
}

Future<bool?> confirmCancelTaskDialog(BuildContext context) {
  return confirmDialog(context,
      prompt: "Are you sure you want to cancel these changes?");
}
