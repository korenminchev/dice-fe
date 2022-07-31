import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart' as game;
import 'package:dice_fe/features/join/domain/join_repository.dart';
import 'package:dice_fe/features/join/domain/room_info.dart';

class JoinRepositoryImpl implements JoinRepository {
  final DiceBackend _backend;

  JoinRepositoryImpl(this._backend);

  @override
  Future<Either<JoinFailure, void>> join(String roomCode) async {
    final joinBackendResult = await _backend.join(roomCode);
    return joinBackendResult.fold((failure) {
      return Left(RoomCodeInvalid());
    }, (_) => const Right(null));
  }

  @override
  Future<Either<JoinFailure, List<RoomInfo>>> getFriendsActiveRooms() {
    throw UnimplementedError();
  }

  @override
  bool isRoomCodeValid(String roomCode) {
    return (roomCode.length == 4 && (int.tryParse(roomCode) != null));
  }

  @override
  Future<Either<JoinFailure, bool>> isRoomCodeJoinable(String roomCode) async {
    final isRoomCodeJoinableBackendResult = await _backend.getGameProgression(roomCode);
    return isRoomCodeJoinableBackendResult.fold((failure) {
      if (failure.statusCode == 404) {
        return Left(RoomCodeInvalid());
      }
      return Left(JoinFailure());
    }, (progression) => Right(progression == game.GameProgression.lobby));
  }
}
