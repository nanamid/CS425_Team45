import 'package:flutter/material.dart';

//PasswordStrengthChecker class declaration
//This class is the password strength checker, which checks the features of the password
//SOURCE: https://medium.com/@kamranbekirovyz/building-a-customizable-password-strength-checker-in-flutter-ac219650305a
class PasswordStrengthChecker extends StatefulWidget {
  const PasswordStrengthChecker({
    super.key,
    required this.password,
    required this.onStrengthChanged,
  });

  final String password;
  final Function(bool isStrong) onStrengthChanged;

  @override
  State<PasswordStrengthChecker> createState() =>
      _PasswordStrengthCheckerState();
}

class _PasswordStrengthCheckerState extends State<PasswordStrengthChecker> {
  @override
  void didUpdateWidget(covariant PasswordStrengthChecker oldWidget) {
    super.didUpdateWidget(oldWidget);

    //Check if the password value has changed
    if (widget.password != oldWidget.password) {
      //If changed, re-validate the password strength
      final isStrong = _validators.entries.every(
        (entry) => entry.key.hasMatch(widget.password),
      );

      //Call callback with new value to notify parent widget
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => widget.onStrengthChanged(isStrong),
      );
    }
  }

  //Variable that maps the validators and presents messages
  //Selected requirements:
  //    1.) One uppercase letter
  //    2.) One special character
  //    3.) 10-32 characters long
  final Map<RegExp, String> _validators = {
    RegExp(r'[A-Z]'): 'One uppercase letter',
    RegExp(r'[!@#\$%^&*(),.?":{}|<>]'): 'One special character',
    RegExp(r'^.{10,32}$'): '10-32 characters',
  };

  @override
  Widget build(BuildContext context) {
    //If the password is empty yet, we'll show validation messages in plain
    // color, not green or red
    final hasValue = widget.password.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _validators.entries.map(
        (entry) {
          /// Check if the password matches the current validator requirement
          final hasMatch = entry.key.hasMatch(widget.password);

          //Based on the match, we'll show the validation message in green or
          // red color
          final color =
              hasValue ? (hasMatch ? Colors.green : Colors.red) : null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              entry.value,
              style: TextStyle(color: color),
            ),
          );
        },
      ).toList(),
    );
  }
}
