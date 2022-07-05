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
  bool joinedRoom = false;

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
  Future<Either<GameFailure, bool>> isRoomCodeValid(
      String roomCode, String playerId) async {
    if (roomCode.length != 4 || !RegExp(r'^[0-9]+$').hasMatch(roomCode)) {
      return Future.value(Left(RoomCodeInvalid()));
    }

    final results = await Future.wait([
      _backend.isPlayerInGame(roomCode, playerId),
      _backend.isRoomCodeJoinable(roomCode),
    ]);

    return results[0].fold(
      (failure) => Left(NetworkError()),
      (playerInGame) {
        if (playerInGame as bool) {
          return Right(playerInGame);
        }

        return results[1].fold(
          (failure) => Left(NetworkError()),
          (gameProgression) => Right(gameProgression == GameProgression.lobby),
        );
      },
    );
  }

  @override
  Future<Either<GameFailure, Stream>> joinRoom(String roomCode) async {
    final joinRoomBackendResult = await _backend.join(roomCode);
    return joinRoomBackendResult.fold((failure) {
      print("Failed getting BE stream");
      return Left(NetworkError());
    }, (stream) {
      joinedRoom = true;
      return Right(backendMessage(stream));
    });
  }

  @override
  Future<Either<GameFailure, Stream>> getGameStream() async {
    if (!joinedRoom) {
      return Left(RoomNotJoined());
    }
    final getGameStreamBackendResult = await _backend.getGameWs();
    return getGameStreamBackendResult.fold((failure) {
      print("Failed getting BE stream");
      return Left(NetworkError());
    }, (stream) {
      return Right(backendMessage(stream));
    });
  }

  Stream<Message> backendMessage(Stream stream) async* {
    await for (final message in stream) {
      Map<String, dynamic> jsonMessage =
          json.decode(message) as Map<String, dynamic>;
      print(jsonMessage);
      yield Message.fromJson(jsonMessage);
    }
  }

  @override
  Either<Failure, void> sendMessage(Message message) {
    final sendMessageBackendResult = _backend.sendToWS(message.toJson());
    return sendMessageBackendResult.fold(
        (failure) => Left(failure), (_) => const Right(null));
  }

  @override
  void exit() {
    _backend.closeWS();
  }
}
