import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:dice_fe/features/game/app/pages/lobby/lobby_controller.dart';
import 'package:dice_fe/features/game/app/widgets/error_text.dart';
import 'package:dice_fe/features/game/app/widgets/player_list.dart';
import 'package:dice_fe/features/game/app/widgets/ready_button.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/game/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:dice_fe/features/game/app/widgets/rules_view.dart';

class NewLobbyPage extends StatefulWidget {
  static String routeName = '/lobby';
  final String roomCode;
  const NewLobbyPage({required this.roomCode, Key? key}) : super(key: key);

  @override
  State<NewLobbyPage> createState() => _NewLobbyPageState();
}

class _NewLobbyPageState extends State<NewLobbyPage> {
  late LobbyController controller =
      LobbyController(widget.roomCode, serviceLocator<GameRepository>(), onCriticalError, setState);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller.onInitState(context);
  }

  void onCriticalError(String message) async {}

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

  @override
  Widget build(BuildContext context) {
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
        body: Builder(
          builder: (context) {
            switch (controller.gameProgression) {
              case GameProgression.lobby:
                return lobbyPageView();
              case GameProgression.inGame:
              // return const GamePageView();
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          },
        ));
  }

  Widget lobbyPageView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 4 * AppUI.heightUnit),
          Text("Room ${widget.roomCode}", style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700)),
          SizedBox(height: 4 * AppUI.heightUnit),
          PlayerList(controller.players),
          Expanded(child: const SizedBox()),
          // const Text("Who sits next to you?", style: TextStyle(fontSize: 18)),
          // SizedBox(height: 2 * AppUI.heightUnit),
          // Row(
          //   children: [
          //     SizedBox(width: 2 * AppUI.widthUnit),
          //     const PlayerPicker(PlayerPickerSide.left),
          //     SizedBox(width: 3 * AppUI.widthUnit),
          //     const PlayerPicker(PlayerPickerSide.right),
          //     SizedBox(width: 2 * AppUI.widthUnit),
          //   ],
          // ),
          SizedBox(height: 16 * AppUI.heightUnit),
          const Text("Game settings", style: TextStyle(fontSize: 24)),
          SizedBox(height: 2 * AppUI.heightUnit),
          RulesView(rules: controller.rules),
          Expanded(child: const SizedBox()),
          ErrorText(controller.errorMessage),
          controller.readyLoading
              ? const CircularProgressIndicator.adaptive()
              : ReadyButton(
                  userReady: controller.userReady, onReadyClicked: () => setState(() => controller.onReadyClicked)),
          SizedBox(height: 4 * AppUI.heightUnit),
        ],
      ),
    );
  }
}
