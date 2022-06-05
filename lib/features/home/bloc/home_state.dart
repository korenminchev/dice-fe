part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class Loading extends HomeState {}

class NavigateJoinGame extends HomeState {

  NavigateJoinGame();
}

class NavigateCreateGame extends HomeState {

  NavigateCreateGame();
}

class NavigateGameRules extends HomeState {}

class Error extends HomeState {
  final String message;

  Error(this.message);
}