import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/failure.dart';

abstract class GameRepository {
  GameRepository();
  Future<Either<Failure, bool>> isRoomCodeValid(String roomCode);
  Future<Either<Failure, Stream>> joinRoom(String roomCode);
}

class GameFailure extends Failure {}

class RoomCodeInvalid extends GameFailure {}

class NetworkError extends GameFailure {}
