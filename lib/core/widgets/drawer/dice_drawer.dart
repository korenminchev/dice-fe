import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:flutter/material.dart';

import 'drawer_item.dart';

class DiceDrawer extends StatelessWidget {
  const DiceDrawer({Key? key}) : super(key: key);
  final double width = 220;

  @override
  Widget build(BuildContext context) {
    AppUI.setUntitsSize(context);
    return SizedBox(
      width: width,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(height: 50),
            DrawerItem(
              icon: const Icon(Icons.account_circle),
              title: 'Change name',
              onTap: () {
                // TODO (Koren) : Push change name screen;
              },
            ),
            DrawerItem(
              icon: const Icon(Icons.group),
              title: 'View friends',
              onTap: () {
                // TODO (Koren) : Push view friends screen;
              },
            ),
            DrawerItem(
              icon: const Icon(Icons.warning_rounded),
              title: 'Report a bug',
              onTap: () {
                // TODO (Koren) : Push bug report screen;
              },
            ),
          ],
        ),
      ),
    );
  }
}