import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/features/create_user/app/pages/create_user_page.dart';
import 'package:dice_fe/features/game/app/bloc/game_bloc.dart';
import 'package:dice_fe/features/game/app/widgets/game_lobby.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/home/pages/home_page.dart';
import 'package:dice_fe/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      const SnackBar(
        content: Text("Room code is invalid"),
      ),
    );
    Navigator.of(context).popUntil(ModalRoute.withName(HomePage.routeName));
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
          int totalDiceCount = state.players.map((player) => player.currentDiceCount).reduce((a, b) => a! + b!)!;
          print(state.toString());
          print(state.dice);
          print(state.players);
          if (state.dice.isEmpty || state.players.isEmpty) {
            
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return Center(
            child: Column(
              children: [
                SizedBox(height: 3 * AppUI.heightUnit),
                Text(
                  "Dice Count - $totalDiceCount",
                ),
                SizedBox(height: 3 * AppUI.heightUnit),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 3 * AppUI.widthUnit,
                  mainAxisSpacing: AppUI.heightUnit,
                  padding: EdgeInsets.symmetric(horizontal: 4 * AppUI.widthUnit),
                  children: state.players.map(
                    (player) => Text("${player.name} - ${player.currentDiceCount}"))
                    .toList()
                ),
                SizedBox(height: 4 * AppUI.heightUnit),
                const Text("Your Dice"),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 3 * AppUI.widthUnit,
                  mainAxisSpacing: AppUI.heightUnit,
                  padding: EdgeInsets.symmetric(horizontal: 4 * AppUI.widthUnit),
                  children: state.dice.map(
                    (dice) => Container(
                      width: 11 * AppUI.widthUnit,
                      height: 11 * AppUI.heightUnit,
                      child: Image.asset("assets/images/Dice/Big/${dice.toString()}.png")
                    ))
                    .toList()
                ),
                SizedBox(height: 15 * AppUI.heightUnit),
                PrimaryButton(
                  text: "Lie!",
                  onTap: () {
                    print("Lie!");
                  })
              ],
            ),
          );
        }

        return const Center(child: Text("Game page"));
      }
    );
  }
}
