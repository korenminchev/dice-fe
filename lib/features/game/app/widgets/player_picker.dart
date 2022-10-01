import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/features/game/domain/models/player_picker_side.dart';
import 'package:flutter/material.dart';

class PlayerPicker extends StatelessWidget {
  final PlayerPickerSide side;
  final bool userReady;
  final DiceUser? selectedPlayer;
  final List<DiceUser> players;
  final void Function(DiceUser?) onPlayerChanged;
  const PlayerPicker(this.side,
      {required this.userReady,
      required this.selectedPlayer,
      required this.players,
      required this.onPlayerChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27.5 * AppUI.widthUnit,
      decoration: BoxDecoration(
        border: Border.all(color: AppUI.lightGrayColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          isExpanded: true,
          value: selectedPlayer,
          items: players
              .map((user) => DropdownMenuItem(
                    value: user,
                    child: Container(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(user.name)),
                  ))
              .toList(),
          onChanged: userReady ? null : (player) => onPlayerChanged(player as DiceUser),
          hint: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Who sits on your ${side.name}?"),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
