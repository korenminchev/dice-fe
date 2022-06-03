part of 'game_bloc.dart';

@immutable
abstract class GameState {}

class GameInitial extends GameState {}

class GameRoomCodeInvalid extends GameState {}

class GameLobbyLoading extends GameState {}
