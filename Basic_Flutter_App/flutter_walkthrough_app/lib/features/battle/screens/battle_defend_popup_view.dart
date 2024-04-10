// battle_defend_view.dart
import 'package:flutter/material.dart';
import 'package:test_app/features/battle/controllers/battle_controller.dart';

class DefendWindowView extends StatelessWidget {
  final BattleViewModel viewModel;

  const DefendWindowView({Key? key, required this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate random damage for display
    //final int randomDamage = 10 + Random().nextInt(11); // Random number between 10 and 20

    return AlertDialog(
      title: Text('Defend!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            viewModel.botRandomAttack; // Use botAttack or a specific method for random damage
            Navigator.of(context).pop();
          },
          child: Text('Take Damage'),
        ),
      ],
    );
  }
}
