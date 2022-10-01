import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:flutter/material.dart';

class PlayerList extends StatelessWidget {
  final List<DiceUser> players;
  const PlayerList(this.players, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: [
        ...players.map((user) => Text(user.name, style: const TextStyle(fontSize: 24))),
      ]),
    );
  }
}
