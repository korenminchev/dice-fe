import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/failure.dart';

abstract class HomeRepository {
  bool isUserLoggedIn();
  Future<Either<Failure, String>> createGame();
}
