part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class JoinGame extends HomeEvent {
  JoinGame();
}

class CreateGameButton extends HomeEvent {
  CreateGameButton();
}

class GameRulesEvent extends HomeEvent {
  GameRulesEvent();
}

class CreateGame extends HomeEvent {
  CreateGame();
}
