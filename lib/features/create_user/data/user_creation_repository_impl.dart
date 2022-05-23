import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:dice_fe/features/create_user/domain/user_createtion_repository.dart';

class UserCreationRepositoryImpl implements UserCreationRepository {
  final DiceBackend _backend;
  final CookieManager _cookieManager;

  UserCreationRepositoryImpl(this._backend, this._cookieManager);

  @override
  Future<Either<UserCreationFailed, void>> createUser(String name) async {
    final response = await _backend.createUser(name);
    return response.fold(
      (failure) => Left(UserCreationFailed()),
      (user) {
        _cookieManager.addToCookie(
          USER_COOKIE_RECORD_NAME,
          jsonEncode(user.toJson())
        );
        return const Right(null);
      }
    );
  }
}
