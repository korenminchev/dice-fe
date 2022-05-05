import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/failure.dart';
import 'package:dice_fe/features/join/domain/room_info.dart';

abstract class JoinRepository {
  Future<Either<JoinFailure, void>> join(String roomCode);
  Future<Either<JoinFailure, List<RoomInfo>>> getFriendsActiveRooms();
}

class JoinFailure extends Failure{}

class RoomDoesntExist extends JoinFailure {}
class GameInProgress extends JoinFailure {}
class RoomCodeInvalid extends JoinFailure {}
