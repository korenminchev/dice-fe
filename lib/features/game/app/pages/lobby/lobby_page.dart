import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'lobby_controller.dart';

class LobbyPage extends View {
  static String routeName = '/lobby';
  final String roomCode;
  LobbyPage({required this.roomCode, Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<LobbyPage> createState() => LobbyPageState(roomCode);
}

class LobbyPageState extends ViewState<LobbyPage, LobbyController> {
  String roomCode;

  LobbyPageState(this.roomCode) : super(LobbyController(roomCode));

  @override
  Widget get view {
    AppUI.setUntitsSize(context);
    return Scaffold(
      drawer: const DiceDrawer(),
      appBar: AppBar(
        title: const DiceAppBarTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(context: context, builder: (context) => buildExitConfirmationDialog(context));
            },
          ),
        ],
      ),
      body: Center(child: Text("Lobby")),
    );
  }

  Widget buildExitConfirmationDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Are you sure you want to exit?",
        style: TextStyle(
          fontSize: 24,
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Leave", style: TextStyle(fontSize: 20, color: Colors.red)),
          onPressed: () {},
        ),
        TextButton(
          child: const Text(
            "Stay",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  // Widget buildLobbyPage() {
  //   AppUI.setUntitsSize(context);
  //   return Center(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         SizedBox(height: 4 * AppUI.heightUnit),
  //         Text(
  //           "Room ${widget.roomCode}",
  //           style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700)
  //         ),
  //         SizedBox(height: 4 * AppUI.heightUnit),
  //         SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           child: Column(
  //             children: [
  //               ...widget.users.map((user) =>
  //               Text(user.name, style: const TextStyle(fontSize: 24))),
  //             ]
  //           ),
  //         ),
  //         const Expanded(child: SizedBox()),
  //         const Text("Who sits next to you?", style: TextStyle(fontSize: 18)),
  //         SizedBox(height: 2 * AppUI.heightUnit),
  //         Row(
  //           children: [
  //             SizedBox(width: 2 * AppUI.widthUnit),
  //             Container(
  //               width: 27.5 * AppUI.widthUnit,
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: AppUI.lightGrayColor),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButton(
  //                   isExpanded: true,
  //                   value: leftUser,
  //                   items: widget.users
  //                     .map((user) => DropdownMenuItem(
  //                       value: user,
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(horizontal: 16),
  //                         child: Text(user.name)
  //                       ),
  //                     ))
  //                     .toList(),
  //                   onChanged: widget.userReady ? null : (user) {
  //                     leftUser = user as DiceUser;
  //                     setState(() {});
  //                   },
  //                   hint: Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 16),
  //                     child: const Text("Who sits on your left?"),
  //                   ),
  //                   borderRadius: BorderRadius.circular(5),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 3 * AppUI.widthUnit),
  //             Container(
  //               width: 27.5 * AppUI.widthUnit,
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: AppUI.lightGrayColor),
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //               child: DropdownButtonHideUnderline(
  //                 child: DropdownButton(
  //                   isExpanded: true,
  //                   value: rightUser,
  //                   items: widget.users
  //                     .map((user) => DropdownMenuItem(
  //                       value: user,
  //                       child: Container(
  //                         padding: EdgeInsets.symmetric(horizontal: 2 * AppUI.widthUnit),
  //                         child: Text(user.name)
  //                       ),
  //                     ))
  //                     .toList(),
  //                   onChanged: widget.userReady ? null : (user) {
  //                     rightUser = user as DiceUser;
  //                     setState(() {});
  //                   },
  //                   hint: Container(
  //                     padding: EdgeInsets.symmetric(horizontal: 2 * AppUI.widthUnit),
  //                     child: const Text("Who sits on your right?"),
  //                   ),
  //                   borderRadius: BorderRadius.circular(5),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(width: 2 * AppUI.widthUnit),
  //           ],
  //         ),
  //         SizedBox(height: 8 * AppUI.heightUnit),
  //         const Text("Game settings", style: TextStyle(fontSize: 24)),
  //         SizedBox(height: 2 * AppUI.heightUnit),
  //         Row(
  //           children: [
  //             SizedBox(width: 4 * AppUI.widthUnit),
  //             Expanded(
  //               child: Column(
  //                 children: [
  //                   const Text(
  //                     "Dice count",
  //                     style: TextStyle(fontSize:18, fontWeight: FontWeight.w300)
  //                   ),
  //                   SizedBox(height: AppUI.heightUnit),
  //                   Text(
  //                     "${widget.rules.initialDiceCount}",
  //                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(width: 4 * AppUI.widthUnit),
  //             Expanded(
  //               child: Column(
  //                 children: [
  //                   const Text(
  //                     "Paso",
  //                     style: TextStyle(fontSize:18, fontWeight: FontWeight.w300)
  //                   ),
  //                   SizedBox(height: AppUI.heightUnit),
  //                   Text(
  //                     widget.rules.pasoAllowed! ? "ON" : "OFF",
  //                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(width: 4 * AppUI.widthUnit),
  //             Expanded(
  //               child: Column(
  //                 children: [
  //                   const Text(
  //                     "Exactly",
  //                     style: TextStyle(fontSize:18, fontWeight: FontWeight.w300)
  //                   ),
  //                   SizedBox(height: AppUI.heightUnit),
  //                   Text(
  //                     widget.rules.exactAllowed! ? "ON" : "OFF",
  //                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(width: 4 * AppUI.widthUnit)
  //           ]
  //         ),
  //         const Expanded(child: SizedBox()),
  //         if (widget.error != null)
  //           Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(widget.error!, style: const TextStyle(color: Colors.red, fontSize: 18)),
  //           ),
  //         if (widget.readyLoading)
  //           const CircularProgressIndicator.adaptive()
  //         else
  //           PrimaryButton(
  //             text: widget.userReady ? "Unready" : "Ready",
  //             width: MediaQuery.of(context).size.width * 0.8,
  //             height: 8 * AppUI.heightUnit,
  //             onTap: (leftUser != null && rightUser != null)
  //               ? () => widget.onReady(!widget.userReady, leftUser!, rightUser!)
  //               : null
  //           ),
  //         SizedBox(height: 4 * AppUI.heightUnit),
  //       ],
  //     ),
  //   );
  // }
}
