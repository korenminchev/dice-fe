import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';

class UserCreationFailed extends Failure {}

abstract class UserCreationRepository {
  Future<Either<Failure, DiceUser>> createUser(String name);
}
