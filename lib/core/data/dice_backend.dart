import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/failure.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerFailure extends Failure {
  final int statusCode;
  final String message;

  ServerFailure(this.statusCode, this.message);

  @override
  String toString() => message;
}

class DiceBackend {
  final String serverUrl = 'http://dice-be.shust.in/';
  WebSocketChannel? _gameChannel;
  late String _userId;

  Future<Either<ServerFailure, http.Response>> _get(String url) async {
    print('GET: $url');
    final response = await http.get(
      Uri.parse('$serverUrl/$url'),
      headers: {
        "Access-Control-Allow-Origin": "Access-Control-Allow-Origin, Accept",
        "Accept": "application/json",
        "Content-Type": "application/json",
      });
    if (response.statusCode == 200) {
      return Right(response);
    } else {
      return Left(ServerFailure(response.statusCode, response.body));
    }
  }

  Future<Either<ServerFailure, Map<String, dynamic>>> _post(String url,
      {Map<String, String>? body}) async {
    final response = await http.post(Uri.parse('$serverUrl/$url'), body: body);
    Map<String, dynamic>? jsonBody = json.decode(response.body);
    if (response.statusCode == 200) {
      return Right(jsonBody ?? {});
    }
    return Left(ServerFailure(response.statusCode, jsonBody?["message"] ?? ""));
  }

  Future<Either<Failure, Stream>> join(String roomCode) async {
    _gameChannel = WebSocketChannel.connect(Uri.parse('$serverUrl/games/ws/$roomCode'));
    return Right(_gameChannel!.stream);
  }

  void init(String userId) {
    _userId = userId;
  }

  Future<Either<ServerFailure, DiceUser>> createUser(String username) async {
    final response = await _post("users", body: {'name': username});
    return response.fold(
      (failure) => Left(failure),
      (response) {
        _userId = response['id'];
        return Right(DiceUser.fromJson(response));
      },
    );
  }

  Future<Either<ServerFailure, bool>> isRoomCodeJoinable(String roomCode) async {
    final response = await _get("games/$roomCode/state");
    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right(response.body == "lobby");
      }
    );
  }
}