import 'package:flutter/material.dart';

class DiceAppBarTitle extends StatelessWidget {
  const DiceAppBarTitle({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Dice",
      style: TextStyle(
        fontFamily: "Hurricane",
        fontSize: 64
      )
    );
  }
}