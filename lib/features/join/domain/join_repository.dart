import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:dice_fe/features/join/domain/room_info.dart';

abstract class JoinRepository {
  Future<Either<JoinFailure, void>> join(String roomCode);
  Future<Either<JoinFailure, List<RoomInfo>>> getFriendsActiveRooms();
  bool isRoomCodeValid(String roomCode);
  Future<Either<JoinFailure, bool>> isRoomCodeJoinable(String roomCode);
}

class JoinFailure extends Failure{}

class RoomCodeInvalid extends JoinFailure {}
