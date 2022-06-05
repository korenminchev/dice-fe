import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/authorization_repository.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:dice_fe/features/create_user/domain/user_createtion_repository.dart';

class UserCreationRepositoryImpl implements UserCreationRepository {
  final DiceBackend _backend;
  final AuthorizationRepository _authorizationRepository;

  UserCreationRepositoryImpl(this._backend, this._authorizationRepository);

  @override
  Future<Either<Failure, DiceUser>> createUser(String name) async {
    return (await _authorizationRepository.createUser(name));
  }
}
