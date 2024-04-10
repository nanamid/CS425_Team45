import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BotHealthBar extends StatelessWidget {
  final Rx<int> botHealth;
  final int maxHealth;

  BotHealthBar({
    Key? key,
    required this.botHealth,
    this.maxHealth = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double fraction = (botHealth.value / maxHealth).clamp(0.0, 1.0);
      return Column(
        children: [
          Text('Bot Health: ${botHealth.value}'),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(
                decoration: BoxDecoration(
                  color: fraction > 0.5 ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
