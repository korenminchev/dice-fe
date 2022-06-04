import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/features/game_rules/app/bloc/gamerules_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: BlocProvider(
          create: (context) => GameRulesBloc(),
          child: buildGameRulesPage(context),
        ),
      ),
    );
  }

  Widget buildGameRulesPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text("Game Rules", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          SizedBox(height: 24),
          Text("Dice is a gambling game played using dice (wow how shocking)\n\n"),
          Text("Setup\n", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}