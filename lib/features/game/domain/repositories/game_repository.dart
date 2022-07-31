import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';

enum GameProgression { lobby, inGame }

Map<String, GameProgression> gameProgressionFromString = {
  'lobby': GameProgression.lobby,
  'in_game': GameProgression.inGame
};

abstract class GameRepository {
  GameRepository();
  Either<Failure, DiceUser> isUserLoggedIn();
  Future<Either<Failure, bool>> isRoomCodeValid(String roomCode, String playerId);
  Future<Either<Failure, bool>> isPlayerInGame(String roomCode, String playerId);
  Future<Either<Failure, Stream>> joinRoom(String roomCode);
  Future<Either<Failure, Stream>> getGameStream();
  Either<Failure, void> sendMessage(Message message);
  Future<Either<Failure, GameProgression>> getGameProgression(String roomCode);
  void exit();
}

class GameFailure extends Failure {}

class RoomNotJoined extends GameFailure {}

class RoomCodeInvalid extends GameFailure {}

class NetworkError extends GameFailure {}
