import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/failure.dart';

class UserCreationFailed extends Failure {}

abstract class UserCreationRepository {
  Future<Either<Failure, void>> createUser(String name);
}
