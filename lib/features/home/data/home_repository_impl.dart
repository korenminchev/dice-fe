import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/authorization_repository.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:dice_fe/features/home/domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final DiceBackend _backend;
  final CookieManager _cookieManager;
  final AuthorizationRepository _authorizationRepository;

  HomeRepositoryImpl(this._backend, this._cookieManager, this._authorizationRepository);
  
  @override
  bool isUserLoggedIn() {
    final loginResult = _authorizationRepository.getUser();
    return loginResult.fold(
      (failure) => false,
      (user) => true,
    );
  }

  @override
  Future<Either<Failure, String>> createGame() async {
    throw UnimplementedError();
    // final response = await _backend.createGame();
    // return response.fold(
    //   (failure) => Left(Failure(message: "Someting went wrong")),
    //   (roomCode) {
    //     if (roomCode.length != 4) {
    //       return Left(Failure(message: "Someting went wrong"));
    //     }
    //     return Right(roomCode);
    //   }
    // );
  }
}
