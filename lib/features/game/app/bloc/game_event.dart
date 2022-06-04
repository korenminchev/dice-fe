part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class CheckCodeValidity extends GameEvent {
  final String roomCode;

  CheckCodeValidity(this.roomCode);
}

class StreamStarted extends GameEvent {}

class ServerMessage extends GameEvent {
  final Message message;

  ServerMessage(this.message);
}
