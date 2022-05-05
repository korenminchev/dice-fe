import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/join/domain/join_repository.dart';
import 'package:dice_fe/features/join/domain/room_info.dart';

class JoinRepositoryImpl implements JoinRepository {
  final DiceBackend _backend;

  JoinRepositoryImpl(this._backend);

  @override
  Future<Either<JoinFailure, void>> join(String roomCode) async {
    final joinBackendResult = await _backend.join(roomCode);
    return joinBackendResult.fold(
      (failure) {
        return Left(RoomCodeInvalid());
      },
      (_) => const Right(null)
    );
  }

  @override
  Future<Either<JoinFailure, List<RoomInfo>>> getFriendsActiveRooms() {
    throw UnimplementedError();
  }

  @override
  Future<Either<JoinFailure, bool>> isRoomCodeValid(String roomCode) async {
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
