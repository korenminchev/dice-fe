import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';

class RulesView extends StatelessWidget {
  final GameRules rules;
  const RulesView({required this.rules, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 4 * AppUI.widthUnit),
      Expanded(
        child: Column(
          children: [
            const Text("Dice count", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            SizedBox(height: AppUI.heightUnit),
            Text("${rules.initialDiceCount}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      SizedBox(width: 4 * AppUI.widthUnit),
      Expanded(
        child: Column(
          children: [
            const Text("Paso", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            SizedBox(height: AppUI.heightUnit),
            Text(rules.pasoAllowed! ? "ON" : "OFF", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      SizedBox(width: 4 * AppUI.widthUnit),
      Expanded(
        child: Column(
          children: [
            const Text("Exactly", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300)),
            SizedBox(height: AppUI.heightUnit),
            Text(rules.exactAllowed! ? "ON" : "OFF", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      SizedBox(width: 4 * AppUI.widthUnit)
    ]);
  }
}
