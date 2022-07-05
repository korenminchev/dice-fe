import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/home/injection_container.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class LobbyPresenter extends Presenter {
  final GameRepository _gameRepository;
  final String roomCode;
  late DiceUser _user;

  Function? lobbyOnComplete;
  Function? lobbyOnError;
  Function? lobbyOnNext;

  LobbyPresenter(this.roomCode) : _gameRepository = serviceLocator<GameRepository>() {
    joinGame();
  }

  void joinGame() async {
    // Check if user is logged in
    final logedInResult = _gameRepository.isUserLoggedIn();
    logedInResult.fold(
      (failure) async {
        lobbyOnError?.call(failure);
        return;
      },
      (user) {
        _user = user;
      },
    );

    // Check room code is valid
    final isRoomCodeValid = await _gameRepository.isRoomCodeValid(roomCode, _user.id);
    isRoomCodeValid.fold((failure) => lobbyOnError?.call(failure), (joinable) async {
      if (joinable) {
        final joinResult = await _gameRepository.joinRoom(roomCode);
        joinResult.fold((l) => lobbyOnError?.call(l), (stream) => handleBackendStream(stream));
      } else {
        lobbyOnError?.call(RoomCodeInvalid());
      }
    });
  }

  void handleBackendStream(Stream stream) {
    stream.listen((message) {
      print("Here");
      print(message);
    });
  }

  void onReady(bool ready, String leftPlayerId, String rightPlayerId) {
    _gameRepository.sendMessage(PlayerReady(ready, leftPlayerId, rightPlayerId));
  }

  @override
  void dispose() {}
}
