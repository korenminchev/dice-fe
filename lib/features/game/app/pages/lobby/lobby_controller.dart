import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/features/create_user/app/pages/create_user_page.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/home/pages/home_page.dart';
import 'package:dice_fe/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

enum PlayerPickerSide { left, right }

class LobbyController extends Controller {
  final String roomCode;
  List<DiceUser> players = [];
  DiceUser? currentPlayer;
  DiceUser? leftPlayer;
  DiceUser? rightPlayer;
  bool userReady = false;
  GameRules rules = GameRules(exactAllowed: true, pasoAllowed: true, initialDiceCount: 5);
  bool readyLoading = false;
  Function()? onReady;
  String? errorMessage;
  final GameRepository _gameRepository;
  LobbyController(this.roomCode, this._gameRepository) : super();

  @override
  void initListeners() {}

  @override
  void onInitState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Here");
      bool codeValid = false;
      // Check if user is logged in
      final logedInResult = _gameRepository.isUserLoggedIn();
      logedInResult.fold(
        (failure) async {
          await Navigator.pushNamed(getContext(), CreateUserPage.routeName, arguments: (DiceUser createdUser) {
            Navigator.pop(getContext());
            currentPlayer = createdUser;
          });
        },
        (user) {
          currentPlayer = user;
        },
      );

      if (currentPlayer == null) {
        return;
      }

      // Check room code is valid
      _gameRepository.isRoomCodeValid(roomCode, currentPlayer!.id).then(
            (isRoomCodeValid) => isRoomCodeValid.fold((failure) {
              onCriticalError("Room code is invalid");
            }, (joinable) {
              if (joinable) {
                handleMessagesStream();
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

  void handleMessagesStream() {}

  void selectPlayer(PlayerPickerSide side, DiceUser? user) {
    if (side == PlayerPickerSide.left) {
      leftPlayer = user;
    } else {
      rightPlayer = user;
    }
    if (leftPlayer != null && rightPlayer != null) {
      onReady = onReadyClicked;
      refreshUI();
    }
  }

  void onReadyClicked() async {
    readyLoading = true;
    refreshUI();
    await Future.delayed(const Duration(seconds: 1));
    readyLoading = false;
    refreshUI();
  }
}
