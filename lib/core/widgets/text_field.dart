import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';

class DiceTextField extends StatelessWidget {
  const DiceTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 288,
      height: 56,
      child: TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppUI.lightGrayColor, width: 1)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppUI.lightGrayColor, width: 2)
        ),
        hintText: "Room code..."
        )
      ),
    );
  }
}
