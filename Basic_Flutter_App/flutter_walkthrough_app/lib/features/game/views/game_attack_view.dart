import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/features/game/controllers/game_controller.dart';

class AttackWindowView extends StatefulWidget {
  @override
  _AttackWindowViewState createState() => _AttackWindowViewState();
}

class _AttackWindowViewState extends State<AttackWindowView> {
  final GameController _gameController = Get.find<GameController>();
  final TextEditingController _damageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.only(bottom: 45),
      child: Container(
        width: 400,
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter Damage',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _damageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Damage',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _applyDamage(),
                child: Text('Apply'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyDamage() {
    if (_damageController.text.isNotEmpty) {
      final damage = int.tryParse(_damageController.text) ?? 0;
      _gameController.playerAttack(damage);
       // Close the dialog
      Navigator.of(context).pop();
      
      
    }
  }

  @override
  void dispose() {
    _damageController.dispose();
    super.dispose();
  }
}
