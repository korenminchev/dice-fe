part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class CheckCodeValidity extends GameEvent {
  final String roomCode;

  CheckCodeValidity(this.roomCode);
}
