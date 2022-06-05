import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/features/home/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({ Key? key }) : super(key: key);

  static const String route = "/create_game";

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  DiceBackend backend = serviceLocator<DiceBackend>();
  GameRules rules = GameRules(
    initialDiceCount: 5,
    pasoAllowed: false,
    exactAllowed: true
  );
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DiceAppBarTitle(),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Create Game",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Game settings",
              style: TextStyle(
                fontSize: 24
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Dice count",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppUI.lightGrayColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: rules.initialDiceCount,
                  items: List.generate(
                    8,
                    (index) => DropdownMenuItem(
                      value: index + 3,
                      child: SizedBox(
                        width: 128,
                        child: Center(child: Text("${index + 3}"))
                      ),
                    )
                  ),
                  onChanged: (newCount) {
                    setState(() {
                      rules.initialDiceCount = newCount as int;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Advanced rules",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700
              )
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cupertino.CupertinoSwitch(
                  value: rules.pasoAllowed!,
                  onChanged: (newValue) => setState(() {
                    rules.pasoAllowed = newValue;
                  })
                ),
                const SizedBox(width: 8),
                const Text(
                  "Paso",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "Player can skip a bet once per round\n"
              "and pass the previous bet to the\n"
              "next player. A paso is valid if a player\n"
              "has 4 dice of the same type, or 5\n"
              "different ones. A player may lie\n"
              "about having a paso.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cupertino.CupertinoSwitch(
                  value: rules.exactAllowed!,
                  onChanged: (newValue) => setState(() {
                    rules.exactAllowed = newValue;
                  })
                ),
                const SizedBox(width: 8),
                const Text(
                  "Exactly",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "If a player thinks that the bet has the\n"
              "exact value of dice he can use the\n"
              "exactly rule. If the dice count isn't\n"
              "exactly as the bet he loses a dice. If\n"
              "he guesses correct and the dice\n"
              "count is exactly the bet, nothing happens.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300
              ),
            ),
            const Expanded(child: SizedBox()),
            if (loading)
              const CircularProgressIndicator.adaptive(),
            if (!loading)
              PrimaryButton(
                text: "Create Game",
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  final result = await backend.createGame(rules);
                  result.fold(
                    (failure) => null,
                    (roomCode) => Navigator.pushReplacementNamed(
                      context,
                      "/game/$roomCode"
                    )
                  );
                }
              ),
            const SizedBox(height: 32)
          ],
        ),
      ),
    );
  }
}