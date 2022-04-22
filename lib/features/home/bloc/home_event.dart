part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class JoinGame extends HomeEvent {
  JoinGame();
}

class CreateGame extends HomeEvent {
  CreateGame();
}

class GameRules extends HomeEvent {
  GameRules();
}
