part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class JoinGame extends HomeEvent {
  JoinGame();
}

class CreateGameButton extends HomeEvent {
  CreateGameButton();
}

class GameRules extends HomeEvent {
  GameRules();
}

class CreateGame extends HomeEvent {
  CreateGame();
}
