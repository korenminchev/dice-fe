import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
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
  GamePage({ 
    required this.roomCode,
    Key? key }) : super(key: key);

  static const String routeName = "/game";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DiceDrawer(),
      appBar: AppBar(
        title: const DiceAppBarTitle(),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            final bloc = GameBloc(serviceLocator<GameRepository>());
            bloc.add(CheckCodeValidity(roomCode));
            return bloc;
            },
          child: buildGamePage(context),
        ),
      ),
    );
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
      listener: (context, state) {
        if (state is GameRoomCodeInvalid) {
          onCriticalError(context, "Room code is invalid");
        }
        if (state is NetworkError) {
          onCriticalError(context, "Network error");
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

        if (state is GameLobbyLoaded) {
          return GameLobby(
            roomCode: roomCode,
            users: state.users,
            currentUser: currentUser ?? DiceUser(id: "123", name: "Anonymous"),
            rules: state.rules,
          );
        }

        return const Center(child: Text("Game page"));
      }
    );
  }
}
