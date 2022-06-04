import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';

abstract class GameRepository {
  GameRepository();
  Either<Failure, DiceUser> isUserLoggedIn();
  Future<Either<Failure, bool>> isRoomCodeValid(String roomCode);
  Future<Either<Failure, Stream>> joinRoom(String roomCode);
  Either<Failure, void> sendMessage(Message message);
  void exit();
}

class GameFailure extends Failure {}

class RoomCodeInvalid extends GameFailure {}

class NetworkError extends GameFailure {}
