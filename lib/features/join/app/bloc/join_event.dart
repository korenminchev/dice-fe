part of 'join_bloc.dart';

@immutable
abstract class JoinEvent {}

class TypingEvent extends JoinEvent {
  final String roomCodeTyped;

  TypingEvent(this.roomCodeTyped);
}

class JoinRequestEvent extends JoinEvent {
  final String roomCode;
  final bool joinAllowed;

  JoinRequestEvent({required this.roomCode, required this.joinAllowed});
}
