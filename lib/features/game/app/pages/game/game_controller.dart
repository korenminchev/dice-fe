import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GameController extends Controller {
  final String roomCode;
  final GameRepository _gameRepository;
  DiceUser? currentPlayer;
  late final Stream _websocketStream;
  GameController(this.roomCode, this._gameRepository) : super();

  @override
  void initListeners() {}

  @override
  void onInitState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final logedInResult = _gameRepository.isUserLoggedIn();
      await logedInResult.fold(
        (failure) async {
            onCriticalError("Error joining game");
        },
        (user) async {
          currentPlayer = user;
        },
      );

      if (currentPlayer == null) {
        return;
      }

      // Check room code is valid
      _gameRepository.isPlayerInGame(roomCode, currentPlayer!.id).then(
            (isRoomCodeValid) => isRoomCodeValid.fold((failure) {
              onCriticalError("Room code is invalid");
            }, (joinable) {
              if (joinable) {
                _joinRoom();
              } else {
                onCriticalError("Room code is invalid");
              }
            }),
          );
    });
  }

  void onCriticalError(String message) {
    ScaffoldMessenger.of(getContext()).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    Navigator.of(getContext()).popUntil(ModalRoute.withName(HomePage.routeName));
  }

    void _joinRoom() async {
    final streamResult = await _gameRepository.joinRoom(roomCode);
    print("Joined room");
    streamResult.fold((failure) {
      onCriticalError("Network error");
    }, (stream) {
      _websocketStream = stream;
    });
  }
}
