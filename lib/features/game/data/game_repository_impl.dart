import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl extends GameRepository {
  DiceBackend _backend;

  GameRepositoryImpl(this._backend);

  @override
  Future<Either<GameFailure, bool>> isRoomCodeValid(String roomCode) async {
    if (roomCode.length != 4 || !RegExp(r'^[0-9]+$').hasMatch(roomCode)) {
      return Future.value(Left(RoomCodeInvalid()));
    }

    final isRoomCodeJoinableBackendResult = await _backend.isRoomCodeJoinable(roomCode);
    return isRoomCodeJoinableBackendResult.fold(
      (failure) {
        return Left(RoomCodeInvalid());
      },
      (isRoomCodeJoinable) => Right(isRoomCodeJoinable)
    );
  }
}
