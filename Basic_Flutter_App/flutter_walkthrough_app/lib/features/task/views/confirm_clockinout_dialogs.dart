import 'package:flutter/material.dart';
import 'package:test_app/common/widgets/confirm_dialog.dart';

Future<dynamic> confirmClockInDialog(BuildContext context) {
  return confirmDialog(context, prompt: "Are you sure you want to clock in?");
}

Future<dynamic> confirmClockOutDialog(BuildContext context) {
  return confirmDialog(context, prompt: "Are you sure you want to clock out?");
}
