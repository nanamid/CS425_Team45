// battle_attack_view.dart
import 'package:flutter/material.dart';
import 'package:test_app/features/battle/controllers/battle_controller.dart';

class AttackPopUpView extends StatefulWidget {
  final BattleViewModel viewModel;

  const AttackPopUpView({Key? key, required this.viewModel}) : super(key: key);

  @override
  _AttackPopUpViewState createState() => _AttackPopUpViewState();
}

class _AttackPopUpViewState extends State<AttackPopUpView> {
  final TextEditingController _damageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attack')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _damageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Damage',
                hintText: 'Enter damage amount',
              ),
            ),
            ElevatedButton(
              onPressed: _performAttack,
              child: Text('Deal Damage'),
            ),
          ],
        ),
      ),
    );
  }

  void _performAttack() {
    final int damage = int.tryParse(_damageController.text) ?? 0;
    widget.viewModel.userAttack(damage);
    Navigator.of(context).pop();
  }
}
