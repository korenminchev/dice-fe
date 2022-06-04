import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class GameLobby extends StatefulWidget {
  final String roomCode;
  final List<DiceUser> users;
  final DiceUser currentUser;
  final GameRules rules;
  final void Function(bool, DiceUser, DiceUser) onReady;
  final bool userReady;
  const GameLobby({Key? key,
    required this.roomCode,
    required this.users,
    required this.currentUser,
    required this.rules,
    required this.onReady,
    required this.userReady
  }) : super(key: key);

  @override
  State<GameLobby> createState() => _GameLobbyState();
}

class _GameLobbyState extends State<GameLobby> {
  DiceUser? leftUser;
  DiceUser? rightUser;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Text(
            "Room ${widget.roomCode}",
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700)
          ),
          const SizedBox(height: 32),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ...widget.users.map((user) => 
                Text(user.name, style: const TextStyle(fontSize: 24))),
              ]
            ),
          ),
          const Expanded(child: SizedBox()),
          const Text("Who sits next to you?", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppUI.lightGrayColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: leftUser,
                      items: widget.users
                        .map((user) => DropdownMenuItem(
                          value: user,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(user.name)
                          ),
                        ))
                        .toList(),
                      onChanged: (user) {
                        leftUser = user as DiceUser;
                        setState(() {});
                      },
                      hint: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Who sits on your left?"),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppUI.lightGrayColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: rightUser,
                      items: widget.users
                        .map((user) => DropdownMenuItem(
                          value: user,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(user.name)
                          ),
                        ))
                        .toList(),
                      onChanged: (user) {
                        rightUser = user as DiceUser;
                        setState(() {});
                      },
                      hint: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text("Who sits on your left?"),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 64),
          const Text("Game settings", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Dice count",
                      style: TextStyle(fontSize:18, fontWeight: FontWeight.w300)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${widget.rules.initialDiceCount}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Paso",
                      style: TextStyle(fontSize:18, fontWeight: FontWeight.w300)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.rules.pasoAllowed! ? "ON" : "OFF",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      "Exactly",
                      style: TextStyle(fontSize:18, fontWeight: FontWeight.w300)
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.rules.exactAllowed! ? "ON" : "OFF",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32)
            ]
          ),
          const Expanded(child: SizedBox()),
          PrimaryButton(
            text: widget.userReady ? "Unready" : "Ready",
            width: MediaQuery.of(context).size.width * 0.8,
            height: 64,
            onTap: (leftUser != null && rightUser != null)
              ? () => widget.onReady(!widget.userReady, leftUser!, rightUser!)
              : null
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
