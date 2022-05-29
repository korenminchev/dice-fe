part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class Loading extends HomeState {}

class NavigateJoinGame extends HomeState {
  final bool isUserLoggedIn;

  NavigateJoinGame(this.isUserLoggedIn);
}

class NavigateCreateGame extends HomeState {
  final bool isUserLoggedIn;

  NavigateCreateGame(this.isUserLoggedIn);
}

class NavigateGameRules extends HomeState {}

class Error extends HomeState {
  final String message;

  Error(this.message);
}

class GameCreated extends HomeState {
  final String roomCode;

  GameCreated(this.roomCode);
}