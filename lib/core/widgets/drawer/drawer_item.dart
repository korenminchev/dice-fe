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
              const SizedBox(width: 10),
              icon,
              const SizedBox(width: 15),
              Text(title, style: const TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Flexible(
                flex: 1,
                child: SizedBox()
              ),
              Flexible(
                flex:4,
                child: SizedBox(
                  height: 1,
                  child: Container(
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.5 * AppUI.heightUnit),
        ],
      ),
    );
  }
}
