import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/authorization_repository.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';

class GameRepositoryImpl extends GameRepository {
  final DiceBackend _backend;
  final AuthorizationRepository _authorizationRepository;

  GameRepositoryImpl(this._backend, this._authorizationRepository);

  @override
  Either<Failure, DiceUser> isUserLoggedIn() {
    final loginResult = _authorizationRepository.getUser();
    return loginResult.fold(
      (failure) => Left(failure),
      (user) => Right(user),
    );
  }

  @override
  Future<Either<GameFailure, bool>> isRoomCodeValid(String roomCode) async {
    if (roomCode.length != 4 || !RegExp(r'^[0-9]+$').hasMatch(roomCode)) {
      return Future.value(Left(RoomCodeInvalid()));
    }

    final isRoomCodeJoinableBackendResult = await _backend.isRoomCodeJoinable(roomCode);
    return isRoomCodeJoinableBackendResult.fold(
      (failure) {
        return Left(RoomCodeInvalid());
      },
      (isRoomCodeJoinable) => Right(isRoomCodeJoinable)
    );
  }

  @override
  Future<Either<GameFailure, Stream>> joinRoom(String roomCode) async {
    final joinRoomBackendResult = await _backend.join(roomCode);
    return joinRoomBackendResult.fold(
      (failure) {
        print("Failed getting BE stream");
        return Left(NetworkError());
      },
      (stream) => Right(backendMessage(stream))
    );
  }

  Stream<Message> backendMessage(Stream stream) async* {
    await for (final message in stream) {
      Map<String, dynamic> jsonMessage = json.decode(message) as Map<String, dynamic>;
      print(jsonMessage);
      yield Message.fromJson(jsonMessage);
    }
  }

  @override
  Either<Failure, void> sendMessage(Message message) {
    final sendMessageBackendResult = _backend.sendToWS(message.toJson());
    return sendMessageBackendResult.fold(
      (failure) => Left(failure),
      (_) => const Right(null)
    );
  }

  @override
  void exit() {
    _backend.closeWS();
  }
}
