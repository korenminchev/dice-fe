part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class CheckCodeValidity extends GameEvent {
  final String roomCode;

  CheckCodeValidity(this.roomCode);
}

class StreamStarted extends GameEvent {}

class ExitGame extends GameEvent {}

class ReadyEvent extends GameEvent {
  bool isReady;
  final DiceUser userOnLeft;
  final DiceUser userOnRight;

  ReadyEvent(this.isReady, this.userOnLeft, this.userOnRight);
}

class ServerMessage extends GameEvent {
  final Message message;

  ServerMessage(this.message);
}
