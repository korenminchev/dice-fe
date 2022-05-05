import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiceTextField extends StatelessWidget {
  final TextAlign textAlign;
  final List<TextInputFormatter>? textInputFormatters;
  const DiceTextField({
    Key? key,
    this.textAlign = TextAlign.start,
    this.textInputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 288,
      height: 56,
      child: TextField(
      textAlign: textAlign,
      inputFormatters: textInputFormatters,
      decoration: const InputDecoration(
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
