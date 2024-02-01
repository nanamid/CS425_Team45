import 'package:flutter/material.dart';

/// Alert dialog that Navigator.pop()s a confirmation value from the user
/// true: 'yes'
/// false: 'no'
///
/// Intended to be called with showDialog()
/// Something like bool confirmation = await showDialog(...)
class ConfirmDialog extends StatelessWidget {
  String title;
  String content;

  ConfirmDialog({
    super.key,
    this.title = 'Confirmation',
    this.content = 'Are you sure?',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context,
                  true); // the true/false return appears as the return value of the await showDialog() call
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text("No")),
      ],
    );
  }
}
