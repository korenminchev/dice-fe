import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/features/create_user/app/pages/create_user_page.dart';
import 'package:dice_fe/features/game/domain/models/player_picker_side.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LobbyController {
  final String roomCode;
  Function(String) onCriticalError;
  void Function(void Function()) onMessageReceived;
  void Function(RoundEnd) onRoundEnd;
  List<DiceUser> players = [];
  DiceUser? currentPlayer;
  DiceUser? leftPlayer;
  DiceUser? rightPlayer;
  bool userReady = false;
  GameRules rules =
      GameRules(exactAllowed: true, pasoAllowed: true, initialDiceCount: 5);
  bool readyLoading = false;
  Function()? onReady;
  late final Stream _websocketStream;
  String? errorMessage;
  final GameRepository _gameRepository;
  GameProgression gameProgression = GameProgression.lobby;

  int totalDiceCount = 0;
  List<int> currentPlayerDice = [];
  DiceUser? selectedUser;
  int? diceLieCount;
  int? selectedDiceType;
  LobbyController(this.roomCode, this._gameRepository, this.onCriticalError,
      this.onMessageReceived, this.onRoundEnd)
      : diceLieCount = 1,
        super();

  Future<void> onInitState(BuildContext context) async {
    print("Here");
    bool codeValid = false;
    // Check if user is logged in
    final logedInResult = await _gameRepository.isUserLoggedIn();
    await logedInResult.fold(
      (failure) async {
        await Navigator.pushNamed(context, CreateUserPage.routeName,
            arguments: (DiceUser createdUser, BuildContext con) {
          Navigator.pop(con);
          currentPlayer = createdUser;
        });
      },
      (user) async {
        currentPlayer = user;
      },
    );

    print(currentPlayer);
    if (currentPlayer == null) {
      return;
    }

    // Check room code is valid
    _gameRepository.isRoomCodeValid(roomCode, currentPlayer!.id).then(
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

    await _gameRepository.getGameProgression(roomCode).then(
          (either) => {
            either.fold((failure) => onCriticalError("Network Error"),
                (_gameProgression) => gameProgression = _gameProgression),
          },
        );

    print(gameProgression);
  }

  void _joinRoom() async {
    final streamResult = await _gameRepository.joinRoom(roomCode);
    print("Joined room");
    streamResult.fold((failure) {
      onCriticalError("Network error");
    }, (stream) {
      _websocketStream = stream;
      _handleBackendStream();
    });
  }

  void _handleBackendStream() {
    print("Handling Stream");
    _websocketStream.listen((message) {
      print("Got Message: ${(message as Message).messageType}");
      switch ((message as Message).messageType) {
        case Event.lobbyUpdate:
          message = message as LobbyUpdate;
          players = message.players;
          rules = message.rules ?? rules;
          if (gameProgression == GameProgression.inGame) {
            totalDiceCount = 0;
            players.forEach((player) {
              totalDiceCount += player.currentDiceCount ?? 0;
            });
          }
          break;

        case Event.readyConfirmation:
          message = message as ReadyConfirmation;
          userReady = message.success;
          readyLoading = false;
          break;

        case Event.gameStart:
          message = message as GameStart;
          gameProgression = GameProgression.inGame;
          print("Game started");
          break;

        case Event.roundStart:
          print("Round started");
          message = message as RoundStart;
          currentPlayerDice = message.dice.toList()..sort();
          break;

        case Event.roundEnd:
          print("Round End");
          onRoundEnd(message as RoundEnd);
          break;

        default:
          break;
      }

      onMessageReceived(() {
        print("SetState");
      });
    });
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

  int get lieDiceCount => diceLieCount ?? (totalDiceCount / 3).round() + 1;

  void selectLieUser(DiceUser? selectedUser) {
    this.selectedUser = selectedUser;
  }

  void setDiceLieCount(int diceLieCount) {
    this.diceLieCount = diceLieCount;
  }

  void selectDiceType(int? selectedDiceTypeIndex) {
    HapticFeedback.selectionClick();
    print("Selected dice type: $selectedDiceTypeIndex");
    selectedDiceType =
        selectedDiceTypeIndex == null ? null : selectedDiceTypeIndex! + 1;
  }

  List<DropdownMenuItem<DiceUser>> get playersWithouthCurrentDropdownItems {
    List<DiceUser> playersWithouthCurrentPlayer =
        players.where((player) => player.id != currentPlayer!.id).toList();
    return playersWithouthCurrentPlayer.map((player) {
      return DropdownMenuItem(
        value: player,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(player.name)),
      );
    }).toList();
  }

  bool get canAccuse => selectedUser != null && selectedDiceType != null;

  void accuse(AccusationType accusationType) {
    _gameRepository.sendMessage(
      Accusation(
          accusedPlayer: selectedUser!.id,
          type: accusationType,
          diceCount: diceLieCount,
          diceValue: selectedDiceType),
    );
    selectedUser = null;
    selectedDiceType = null;
  }

  void leaveRoom() {
    _gameRepository.sendMessage(PlayerLeave());
    _gameRepository.exit();
    // Navigator.of(getContext()).popUntil(ModalRoute.withName(HomePage.routeName));
  }

  void selectPlayer(PlayerPickerSide side, DiceUser? user) {
    if (side == PlayerPickerSide.left) {
      leftPlayer = user;
    } else {
      rightPlayer = user;
    }
    if (leftPlayer != null && rightPlayer != null) {
      onReady = onReadyClicked;
      // refreshUI();
    }
  }

  void onReadyClicked() async {
    readyLoading = true;
    onMessageReceived(() {});
    _gameRepository.sendMessage(
        PlayerReady(!userReady, currentPlayer!.id, currentPlayer!.id));
  }
}
