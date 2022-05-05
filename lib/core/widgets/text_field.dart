import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiceTextField extends StatelessWidget {
  final TextAlign textAlign;
  final List<TextInputFormatter>? textInputFormatters;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const DiceTextField({
    Key? key,
    this.textAlign = TextAlign.start,
    this.textInputFormatters,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 288,
      height: 56,
      child: TextField(
        onChanged: onChanged,
        controller: controller,
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
