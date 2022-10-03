import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/features/game/app/pages/lobby/lobby_controller.dart';
import 'package:dice_fe/features/game/app/widgets/error_text.dart';
import 'package:dice_fe/features/game/app/widgets/player_list.dart';
import 'package:dice_fe/features/game/app/widgets/ready_button.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/game/injection_container.dart';
import 'package:dice_fe/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:dice_fe/features/game/app/widgets/rules_view.dart';
import 'package:numberpicker/numberpicker.dart';

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

    // Because controller.onInitState is async will be called during the build of LobbyPage
    // but it pushes a new screen in case of unregistered user, it needs to be called after
    // LobbyPage is finished building its frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.onInitState(context);
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> initializeController() async {}

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
          onPressed: () {
            controller.leaveRoom();
            Navigator.of(context).popUntil(ModalRoute.withName(HomePage.routeName));
          },
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

  Widget liePopupDialog(BuildContext context, AccusationType accusationType) {
    return Dialog(
      child: StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2 * AppUI.widthUnit,
            vertical: 2 * AppUI.heightUnit,
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              controller.topLieText(accusationType),
              style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2 * AppUI.heightUnit),
            Container(
              width: 35 * AppUI.widthUnit,
              decoration: BoxDecoration(
                border: Border.all(color: AppUI.lightGrayColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  value: controller.selectedUser,
                  items: controller.playersWithouthCurrentDropdownItems,
                  onChanged: (player) => setState(() {
                    controller.selectLieUser(player as DiceUser);
                    print(controller.selectedUser!.name);
                  }),
                  hint: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: const Text("Select a player"),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            SizedBox(height: 2 * AppUI.heightUnit),
            const Text("Dice Count", style: TextStyle(fontSize: 18)),
            SizedBox(height: 2 * AppUI.heightUnit),
            NumberPicker(
              value: controller.lieDiceCount,
              axis: Axis.horizontal,
              minValue: 1,
              maxValue: controller.totalDiceCount,
              step: 1,
              itemWidth: 10 * AppUI.widthUnit,
              haptics: true,
              onChanged: (value) => setState(() => controller.setDiceLieCount(value)),
            ),
            SizedBox(height: 2 * AppUI.heightUnit),
            const Text(
              "Dice Type",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 2 * AppUI.heightUnit),
            GridView.count(
              childAspectRatio: AppUI.widthUnit / AppUI.heightUnit,
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 2 * AppUI.widthUnit,
              mainAxisSpacing: 2 * AppUI.heightUnit,
              controller: ScrollController(keepScrollOffset: false),
              padding: EdgeInsets.zero,
              children: List.generate(
                6,
                (index) => SizedBox(
                  height: 10 * AppUI.heightUnit,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: controller.selectedDiceType != null && controller.selectedDiceType == index + 1
                          ? Colors.grey[600]
                          : null,
                    ),
                    height: 8 * AppUI.heightUnit,
                    width: 8 * AppUI.widthUnit,
                    child: GestureDetector(
                      child: Image.asset(
                        "assets/images/Dice/Big/${index + 1}.png",
                        width: 10 * AppUI.widthUnit,
                      ),
                      onTap: () => setState(() {
                        controller.selectDiceType(index);
                        print(controller.selectedDiceType);
                      }),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4 * AppUI.heightUnit),
            PrimaryButton(
              text: controller.accuseButtonText(accusationType),
              onTap: controller.canAccuse
                  ? () {
                      controller.accuse(accusationType);
                      Navigator.of(context).pop();
                    }
                  : null,
            )
          ]),
        );
      }),
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
            if (isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            switch (controller.gameProgression) {
              case GameProgression.lobby:
                return lobbyPageView();
              case GameProgression.inGame:
                return gamePageView();
            }
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
              : ReadyButton(userReady: controller.userReady, onReadyClicked: controller.onReadyClicked),
          SizedBox(height: 4 * AppUI.heightUnit),
        ],
      ),
    );
  }

  Widget gamePageView() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 3 * AppUI.heightUnit),
          Text(
            "Dice Count - ${controller.totalDiceCount}",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3 * AppUI.heightUnit),
          GridView.count(
              childAspectRatio: AppUI.widthUnit / (AppUI.heightUnit / 4),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 3 * AppUI.widthUnit,
              mainAxisSpacing: AppUI.heightUnit,
              padding: EdgeInsets.symmetric(horizontal: 4 * AppUI.widthUnit),
              children: controller.players
                  .map((player) => Text(
                        "${player.name} - ${player.currentDiceCount}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ))
                  .toList()),
          SizedBox(height: 2 * AppUI.heightUnit),
          const Divider(),
          SizedBox(height: 2 * AppUI.heightUnit),
          const Text(
            "Your Dice",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 40 * AppUI.heightUnit,
            child: GridView.count(
              childAspectRatio: AppUI.widthUnit / AppUI.heightUnit,
              shrinkWrap: true,
              crossAxisCount: 3,
              controller: ScrollController(keepScrollOffset: false),
              padding: EdgeInsets.zero,
              children: controller.currentPlayerDice
                  .map(
                    (dice) => Padding(
                      padding: EdgeInsets.all(AppUI.heightUnit * 2),
                      child: Image.asset("assets/images/Dice/Big/${dice.toString()}.png"),
                    ),
                  )
                  .toList(),
            ),
          ),
          Expanded(child: SizedBox(height: 15 * AppUI.heightUnit)),
          PrimaryButton(
            text: "Accuse!",
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => liePopupDialog(context, AccusationType.standard),
              );
            },
            // popupActionsBuilder: advancedRules
            //     ? (BuildContext context) => <PopupMenuEntry<AccusationType>>[
            //           if (state.rules.pasoAllowed!)
            //             const PopupMenuItem<AccusationType>(
            //               value: AccusationType.paso,
            //               child: Text('Paso'),
            //             ),
            //           if (state.rules.exactAllowed!)
            //             const PopupMenuItem<AccusationType>(
            //               value: AccusationType.exact,
            //               child: Text('Exact'),
            //             ),
            //         ]
            //     : null,
            // onPopupItemSelected: advancedRules
            //     ? (accusationType) {
            //         switch (accusationType) {
            //           case AccusationType.paso:
            //             break;

            //           case AccusationType.exact:
            //             showDialog(
            //                 context: context,
            //                 builder: (context) =>
            //                     buildAccusationPopup(context, state, totalDiceCount, AccusationType.exact));
            //             break;

            //           default:
            //             break;
            //         }
            //       }
            //     : null,
          ),
          SizedBox(height: 4 * AppUI.heightUnit),
        ],
      ),
    );
  }
}
