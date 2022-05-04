part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class NavigateJoinGame extends HomeState {}

class NavigateCreateGame extends HomeState {}

class NavigateGameRules extends HomeState {}
