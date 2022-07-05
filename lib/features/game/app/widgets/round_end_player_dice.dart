import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';

class RoundEndPlayerDice extends StatelessWidget {
  final String name;
  final int jokerCount;
  final int diceCount;
  final int diceValue;

  const RoundEndPlayerDice({
      required this.name,
      required this.jokerCount,
      required this.diceCount,
      required this.diceValue,
      Key? key 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: AppUI.heightUnit
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/Dice/Big/1.png",
              width: 24,
            ),
            Text(
              "  -  ${jokerCount.toString()}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (diceValue != 1)
          Padding(
            padding: EdgeInsets.all(AppUI.heightUnit),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/Dice/Big/$diceValue.png",
                  width: 24,
                ),
                Text(
                  "  -  ${diceCount.toString()}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const Divider(),
        Text(
          "Total - ${(jokerCount + diceCount).toString()}",
          style: const TextStyle(fontSize: 16)
        )
      ],
    );
  }
}