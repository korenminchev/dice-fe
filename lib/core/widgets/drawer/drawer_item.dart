import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final Function() onTap;

  const DrawerItem({required this.icon, required this.title, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: <Widget>[
              const SizedBox(width: 16),
              icon,
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontSize: 20)),
            ],
          ),
          SizedBox(height: 4 * AppUI.heightUnit),
        ],
      ),
    );
  }
}
