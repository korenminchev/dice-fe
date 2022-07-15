import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/features/home/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter_touch_spin/flutter_touch_spin.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({Key? key}) : super(key: key);

  static const String route = "/create_game";

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  DiceBackend backend = serviceLocator<DiceBackend>();
  GameRules rules = GameRules(initialDiceCount: 5, pasoAllowed: true, exactAllowed: true);
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    AppUI.setUntitsSize(context);
    return Scaffold(
      appBar: AppBar(
        title: const DiceAppBarTitle(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2 * AppUI.heightUnit),
            const Text(
              "Game Settings",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 5 * AppUI.heightUnit),
            const Text(
              "Dice count",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 2 * AppUI.heightUnit),
            Container(
              width: 30 * AppUI.widthUnit,
              decoration: BoxDecoration(
                border: Border.all(color: AppUI.lightGrayColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TouchSpin(
                min: 1,
                max: 10,
                value: rules.initialDiceCount as num,
                step: 1,
                onChanged: (value) {
                  rules.initialDiceCount = value as int;
                },
              ),
            ),
            SizedBox(height: 5 * AppUI.heightUnit),
            const Divider(),
            SizedBox(height: 5 * AppUI.heightUnit),
            const Text("Advanced rules", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            SizedBox(height: AppUI.heightUnit),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cupertino.CupertinoSwitch(
                    value: rules.pasoAllowed!,
                    activeColor: AppUI.primaryColor,
                    onChanged: (newValue) => setState(() {
                          rules.pasoAllowed = newValue;
                        })),
                SizedBox(width: AppUI.widthUnit),
                const Text(
                  "Paso",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 2 * AppUI.widthUnit),
                Tooltip(
                  message: "Player can skip a bet once per round\n"
                      "and pass the previous bet to the\n"
                      "next player. A paso is valid if a player\n"
                      "has 4 dice of the same type, or 5\n"
                      "different ones. A player may lie\n"
                      "about having a paso.",
                  textStyle: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3 * AppUI.heightUnit),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cupertino.CupertinoSwitch(
                    value: rules.exactAllowed!,
                    activeColor: AppUI.primaryColor,
                    onChanged: (newValue) => setState(() {
                          rules.exactAllowed = newValue;
                        })),
                SizedBox(width: AppUI.widthUnit),
                const Text(
                  "Exact",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 2 * AppUI.widthUnit),
                Tooltip(
                  message: "If a player thinks that the bet has the\n"
                      "exact value of dice he can use the\n"
                      "exactly rule. If the dice count isn't\n"
                      "exactly as the bet he loses a dice. If\n"
                      "he guesses correct and the dice\n"
                      "count is exactly the bet, nothing happens.",
                  textStyle: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  showDuration: const Duration(seconds: 30),
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8 * AppUI.heightUnit),
            if (loading) const CircularProgressIndicator.adaptive(),
            if (!loading)
              PrimaryButton(
                  text: "Create Game",
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    final result = await backend.createGame(rules);
                    result.fold((failure) => null, (roomCode) => Navigator.pushReplacementNamed(context, "/lobby/$roomCode"));
                  }),
            SizedBox(height: 4 * AppUI.heightUnit),
          ],
        ),
      ),
    );
  }
}
