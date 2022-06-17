part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class VerifyParams extends GameEvent {
  final String roomCode;

  VerifyParams(this.roomCode);
}

class StreamStarted extends GameEvent {}

class ExitGame extends GameEvent {}

class ReadyEvent extends GameEvent {
  final bool isReady;
  final DiceUser userOnLeft;
  final DiceUser userOnRight;

  ReadyEvent(this.isReady, this.userOnLeft, this.userOnRight);
}

class JoinGame extends GameEvent {
  final String roomCode;
  final DiceUser user;

  JoinGame(this.roomCode, this.user);
}

class AccusationEvent extends GameEvent {
  AccusationEvent({
    required this.accusedUser,
    required this.type,
    this.diceCount,
    this.diceValue,
  });

  final DiceUser accusedUser;
  final AccusationType type;
  final int? diceCount;
  final int? diceValue;
}

class ServerMessage extends GameEvent {
  final Message message;

  ServerMessage(this.message);
}
