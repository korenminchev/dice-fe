import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/authorization_repository.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';

class NoUserId extends Failure{}

class AuthorizationRepositoryImpl implements AuthorizationRepository {
  final DiceBackend _diceBackend;
  final CookieManager _cookieManager;
  AuthorizationRepositoryImpl(this._diceBackend, this._cookieManager);

  @override
  Either<Failure, DiceUser> getUser() {
    final userData = _cookieManager.getCookie(userCookieRecordName);
    if (userData.isNotEmpty) {
      Map<String, dynamic> userJson = jsonDecode(userData);
      _diceBackend.init(userJson);
      return Right(DiceUser.fromJson(userJson));
    }
    return Left(NoUserId());
  }

  @override
  Future<Either<Failure, DiceUser>> createUser(String username) async {
    final createResult = await _diceBackend.createUser(username);
    return createResult.fold(
      (failure) => Left(failure),
      (user) {
        _cookieManager.addToCookie(userCookieRecordName, json.encode(user.toJson()));
        return Right(user);
      },
    );
  }
}
