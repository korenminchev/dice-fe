import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GameRulesPage extends StatelessWidget {
  const GameRulesPage({ Key? key }) : super(key: key);
  
  static const String routeName = '/game_rules';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DiceAppBarTitle()
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Game Rules", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              const Text("Dice is a gambling game played using dice (wow how shocking)\n\n"),
              const Text("Setup\n", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const Text(
                "All of the players start with the same amount of \n"
                "dice, decided at the start of the game.",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "Each player can only see his own dice set.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)
              ),
              Image.asset(
                "assets/images/initial_rules.png",
              )
            ],
          ),
        )
      ),
    );
  }
}