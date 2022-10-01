import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ReadyButton extends StatelessWidget {
  final bool userReady;
  final void Function()? onReadyClicked;
  const ReadyButton({ required this.userReady, this.onReadyClicked, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
        text: userReady ? "Unready" : "Ready",
        width: MediaQuery.of(context).size.width * 0.8,
        height: 8 * AppUI.heightUnit,
        onTap: onReadyClicked);
  }
}
