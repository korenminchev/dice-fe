part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class NavigateJoinGame extends HomeState {
  final bool isUserLoggedIn;

  NavigateJoinGame(this.isUserLoggedIn);
}

class NavigateCreateGame extends HomeState {
  final bool isUserLoggedIn;

  NavigateCreateGame(this.isUserLoggedIn);
}

class NavigateGameRules extends HomeState {}
