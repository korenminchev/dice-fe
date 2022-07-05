import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/features/create_user/app/pages/create_user_page.dart';
import 'package:dice_fe/features/game/app/bloc/game_bloc.dart';
import 'package:dice_fe/features/game/app/widgets/game_lobby.dart';
import 'package:dice_fe/features/game/app/widgets/round_end_player_dice.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/home/pages/home_page.dart';
import 'package:dice_fe/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

class GamePage extends StatelessWidget {
  final String roomCode;
  DiceUser? currentUser;
  late GameBloc gameBloc;
  GamePage({ 
    required this.roomCode,
    Key? key }) : super(key: key);

  static const String routeName = "/game";

  @override
  Widget build(BuildContext context) {
    AppUI.setUntitsSize(context);
    return Scaffold(
      drawer: const DiceDrawer(),
      appBar: AppBar(
        title: const DiceAppBarTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => buildExitConfirmationDialog(context)
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            gameBloc = GameBloc(serviceLocator<GameRepository>());
            gameBloc.add(VerifyParams(roomCode));
            return gameBloc;
            },
          child: buildGamePage(context),
        ),
      ),
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
          child: const Text(
            "Leave",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red
            )
          ),
          onPressed: () {
            gameBloc.add(ExitGame());
            Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          },
        ),
        TextButton(
          child:  const Text(
            "Stay",
            style: TextStyle(
              fontSize: 20
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void onUserReady(bool isReady, DiceUser userOnLeft, DiceUser userOnRight) {
    gameBloc.add(ReadyEvent(isReady, userOnLeft, userOnRight));
  }

  void onCriticalError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    Navigator.of(context).popUntil(ModalRoute.withName(HomePage.routeName));
  }

  String topLieText(AccusationType accusationType) {
    switch (accusationType) {
      case AccusationType.standard:
        return "Who Lied?";
      case AccusationType.exact:
        return "Who was exact?";
      default:
        return "";
    }
  }

  String accuseButtonText(AccusationType accusationType) {
    switch (accusationType) {
      case AccusationType.standard:
        return "Confirm Lier";
      case AccusationType.exact:
        return "Confirm Exact";
      default:
        return "";
    }
  }

  Widget buildAccusationPopup(BuildContext context, GameReady state, int totalDiceCount, AccusationType accusationType) {
    DiceUser? selectedUser;
    int diceLieCount = (totalDiceCount / 3).round() + 1;
    int? selectedDiceType;

    return StatefulBuilder(builder: ((context, setState) {
      return Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2 * AppUI.widthUnit,
            vertical: 2 * AppUI.heightUnit,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                topLieText(accusationType),
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold
                ),
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
                    value: selectedUser,
                    items: state.players
                      .map((user) => DropdownMenuItem(
                        value: user,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(user.name)
                        ),
                      ))
                      .toList(),
                    onChanged: (user) {
                      setState(() => selectedUser = user as DiceUser);
                    },
                    hint: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text("Select a player"),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 2 * AppUI.heightUnit),
              const Text(
                "Dice Count",
                style: TextStyle(
                  fontSize: 18
                )
              ),
              SizedBox(height: 2 * AppUI.heightUnit),
              NumberPicker(
                value: diceLieCount,
                axis: Axis.horizontal,
                minValue: 1,
                maxValue: totalDiceCount,
                step: 1,
                itemWidth: 10 * AppUI.widthUnit,
                haptics: true,
                onChanged: (value) => setState(() => diceLieCount = value),
              ),
              SizedBox(height: 2 * AppUI.heightUnit),
              const Text(
                "Dice Type",
                style: TextStyle(
                  fontSize: 18
                ),
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
                children: List.generate(6 , (index) => SizedBox(
                  height: 10 * AppUI.heightUnit,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: selectedDiceType != null && selectedDiceType == index + 1
                        ? Colors.grey[600] : null,
                    ),
                    height: 8 * AppUI.heightUnit,
                    width: 8 * AppUI.widthUnit,
                    child: GestureDetector(
                      child: Image.asset(
                        "assets/images/Dice/Big/${index + 1}.png",
                        width: 10 * AppUI.widthUnit,
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => selectedDiceType = index + 1);
                      },
                    )  
                  ),
                ))
              ),
              SizedBox(height: 4 * AppUI.heightUnit),
              PrimaryButton(
                text: accuseButtonText(accusationType),
                onTap: selectedDiceType != null && selectedUser != null ? () {
                  gameBloc.add(AccusationEvent(
                    type: accusationType,
                    accusedUser: selectedUser!,
                    diceValue: selectedDiceType,
                    diceCount: diceLieCount
                  ));
                  Navigator.of(context).pop();
                } : null
              )
            ]
          )
        ),
      );
    }));
  }

  List<Widget> buildStandardEndRound(RoundEnd roundEnd) {
    List<Widget> widgets = [];
    return widgets;
  }

  Widget buildRoundEndPopup(BuildContext context, RoundEndState state) {
    final RoundEnd roundEnd = state.roundEnd;
    String winnerName = roundEnd.players.firstWhere((player) => player.id == roundEnd.winner).name;
    List<Widget> widgets = [];

    switch(roundEnd.accusationType) {
      case AccusationType.standard:
      case AccusationType.exact:
        widgets.add(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Total ",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            Image.asset(
              "assets/images/Dice/Big/1.png",
              width: 24
            ),
            if (roundEnd.diceValue != 1)
              ...[
              const Text(
                " + ",
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              Image.asset(
                "assets/images/Dice/Big/${roundEnd.diceValue}.png",
                width: 24
              ),
              ],
            const Text(
              " :",
              style: TextStyle(
                fontSize: 20
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2 * AppUI.widthUnit),
              child: Text(
                "${roundEnd.diceCount! + roundEnd.jokerCount!}",
                style: const TextStyle(
                  fontSize: 20
                ),
              ),
            )
          ],
        ));
        widgets.add(SizedBox(height: 3 * AppUI.heightUnit));
        widgets.add(GridView.count(
          childAspectRatio: AppUI.widthUnit / (AppUI.heightUnit * 1.5),
          shrinkWrap: true,
          crossAxisCount: 3,
          children: roundEnd.players.map((player) => RoundEndPlayerDice(
            name: player.name,
            jokerCount: player.dice!.where((dice) => dice == 1).length,
            diceValue: roundEnd.diceValue!,
            diceCount: player.dice!.where((dice) => dice == roundEnd.diceValue).length,
          )).toList()
        ));
        break;

      default:
        break;
    }

    return Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2 * AppUI.widthUnit,
            vertical: 2 * AppUI.heightUnit,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                winnerName + " Won",
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 2 * AppUI.heightUnit),
              ...widgets
            ],
          )
        )
    );
  }

  Widget buildGamePage(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) async {
        if (state is GameRoomCodeInvalid) {
          onCriticalError(context, "Room code is invalid");
        }
        if (state is NetworkError) {
          onCriticalError(context, "Network error");
        }
        if (state is GameUserNotLoggedIn) {
          await Navigator.pushNamed(
            context,
            CreateUserPage.routeName,
            arguments: (DiceUser createdUser) {
              Navigator.pop(context);
              gameBloc.add(VerifyParams(roomCode));
            });
        }
        if (state is RoundEndState) {
          showDialog(
            context: context, 
            builder: (context) =>  buildRoundEndPopup(context, state)
          );
        }
      },
      builder: (context, state) {
        if (state is GameInitial) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is GameLobbyLoading) {
          currentUser = state.currentUser;
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (state is GameLobbyReady) {
          return GameLobby(
            roomCode: roomCode,
            users: state.users,
            currentUser: currentUser ?? DiceUser(id: "123", name: "Anonymous"),
            rules: state.rules,
            onReady: onUserReady,
            userReady: state.userReady,
            readyLoading: state.readyLoading,
            error: state.error,
          );
        }

        if (state is GameReady) {
          print(state.toString());
          print(state.dice);
          print(state.players);
          bool advancedRules = state.rules.exactAllowed! || state.rules.pasoAllowed!;
          if (state.dice.isEmpty || state.players.isEmpty) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          int totalDiceCount = state.players.map((player) => player.currentDiceCount).reduce((a, b) => a! + b!)!;
          List<int> orderedDice = state.dice.toList()..sort();
          return Center(
            child: Column(
              children: [
                SizedBox(height: 3 * AppUI.heightUnit),
                Text(
                  "Dice Count - $totalDiceCount",
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
                  children: state.players.map(
                    (player) => Text(
                      "${player.name} - ${player.currentDiceCount}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  ).toList()
                ),
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
                    children: orderedDice.map(
                      (dice) => Padding(
                        padding: EdgeInsets.all(AppUI.heightUnit * 2),
                        child: Image.asset("assets/images/Dice/Big/${dice.toString()}.png"),
                      )
                    )
                      .toList()
                  ),
                ),
                Expanded(child: SizedBox(height: 15 * AppUI.heightUnit)),
                PrimaryButton(
                  text: "Accuse!",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => buildAccusationPopup(context, state, totalDiceCount, AccusationType.standard),
                    );
                  },
                  popupActionsBuilder: advancedRules ?
                    (BuildContext context) => <PopupMenuEntry<AccusationType>>[
                      if (state.rules.pasoAllowed!)
                        const PopupMenuItem<AccusationType>(
                          value: AccusationType.paso,
                          child: Text('Paso'),
                        ),
                      if (state.rules.exactAllowed!)
                      const PopupMenuItem<AccusationType>(
                        value: AccusationType.exact,
                        child: Text('Exact'),
                      ),
                    ] : null,
                  onPopupItemSelected: advancedRules ?
                    (accusationType) {
                      switch (accusationType) {
                        case AccusationType.paso:
                          break;

                        case AccusationType.exact:
                          showDialog(
                            context: context,
                            builder: (context) => buildAccusationPopup(context, state, totalDiceCount, AccusationType.exact)
                          );
                          break;
                        
                        default:
                          break;
                      }
                    }
                    : null,
                ),
                SizedBox(height: 4 * AppUI.heightUnit),
              ],
            ),
          );
        }

        return const Center(child: Text("Game page"));
      }
    );
  }
}
