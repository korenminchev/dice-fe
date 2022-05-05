import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function() onTap;
  final String text;
  const PrimaryButton({required this.text, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(AppUI.primaryColor),
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: onTap,
      child: Container(
        width: 288,
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
