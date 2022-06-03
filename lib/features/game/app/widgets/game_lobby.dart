import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:flutter/material.dart';

class GameLobby extends StatelessWidget {
  final String roomCode;
  final List<DiceUser> users;
  const GameLobby({Key? key,
    required this.roomCode,
    required this.users,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Room $roomCode"),
        const Divider(),
        ...users.map((user) => Text(user.name)),
      ],
    );
  }
}