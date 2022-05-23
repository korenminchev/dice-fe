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
  final String serverUrl = 'https://dice-be.shust.in';
  WebSocketChannel? _gameChannel;
  late String _userId;

  Future<Either<ServerFailure, http.Response>> _get(String url) async {
    print('GET: $url');
    final response = await http.get(
      Uri.parse('$serverUrl/$url'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers": 'Authorization, Origin, X-Requested-With, Content-Type, Accept',
        "Accept": "application/json",
        "Content-Type": "application/json",
      });
    if (response.statusCode == 200) {
      return Right(response);
    } else {
      print("RESPONSE: ${response.statusCode}");
      print(response.body);
      return Left(ServerFailure(response.statusCode, response.body));
    }
  }

  Future<Either<ServerFailure, http.Response>> _post(String url,
      {Map<String, String>? body}) async {
    print('POST: $url');
    print(json.encode(body));
    final response = await http.post(
      Uri.parse('$serverUrl/$url'),
      headers: {
        "Content-Type": "application/json",
        "Access-Control-Allow-Headers": 'Authorization, Origin, X-Requested-With, Content-Type, Accept',
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Origin": "*",
        },
      body: json.encode(body)
    );
    if (response.statusCode == 200) {
      return Right(response);
    }
    print("RESPONSE: ${response.statusCode}");
    print(response.body);
    return Left(ServerFailure(response.statusCode, response.body));
  }

  Future<Either<Failure, Stream>> join(String roomCode) async {
    _gameChannel = WebSocketChannel.connect(Uri.parse('$serverUrl/games/ws/$roomCode'));
    return Right(_gameChannel!.stream);
  }

  Future<Either<Failure, Stream>> getGameWs() async {
    if (_gameChannel == null) {
      return Left(Failure());
    }
    
    return Right(_gameChannel!.stream);
  }

  void init(String userId) {
    _userId = userId;
  }

  Future<Either<ServerFailure, DiceUser>> createUser(String username) async {
    final response = await _post("users/", body: {"name": username});
    return response.fold(
      (failure) => Left(failure),
      (response) {
        Map<String, dynamic> userJson = json.decode(response.body);
        _userId = userJson['id'];
        return Right(DiceUser.fromJson(userJson));
      },
    );
  }

  Future<Either<ServerFailure, String>> createGame() async {
    final response = await _post("games/");
    return response.fold(
      (failure) => Left(failure),
      (response) => Right(json.decode(response.body)),
    );
  }

  Future<Either<ServerFailure, bool>> isRoomCodeJoinable(String roomCode) async {
    final response = await _get("games/$roomCode/state");
    return response.fold(
      (failure) => Left(failure),
      (response) {
        return Right(json.decode(response.body) == "lobby");
      }
    );
  }
}