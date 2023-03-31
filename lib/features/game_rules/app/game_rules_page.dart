import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';

class GameRulesPage extends StatefulWidget {
  static const String route = "game_rules";
  const GameRulesPage({Key? key}) : super(key: key);

  @override
  State<GameRulesPage> createState() => _GameRulesPageState();
}

class _GameRulesPageState extends State<GameRulesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DiceAppBarTitle(),
      ),
      body: Column(
        children: const [
          Center(
            child: Text("GameRules"),
          ),
        ],
      ),
    );
  }
}
