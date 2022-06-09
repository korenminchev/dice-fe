import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final double? width;
  final double? height;
  const PrimaryButton(
    {required this.text,
    required this.onTap,
    this.width,
    this.height,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppUI.setUntitsSize(context);
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          onTap != null ? AppUI.primaryColor : AppUI.lightGrayColor,),
        splashFactory: NoSplash.splashFactory,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          )
        )
      ),
      onPressed: onTap,
      child: SizedBox(
        width: width ?? AppUI.widthUnit * 36,
        height: height ?? AppUI.heightUnit * 7,
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
