import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/failure.dart';

class NoUserId extends Failure{}

abstract class AuthorizationRepository {
  Future<Either<Failure, DiceUser>> getUser();
  Future<Either<Failure, DiceUser>> createUser(String username);
}
