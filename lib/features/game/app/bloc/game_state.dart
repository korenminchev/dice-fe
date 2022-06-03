part of 'game_bloc.dart';

@immutable
abstract class GameState extends Equatable {
  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameRoomCodeInvalid extends GameState {}

class GameLobbyLoading extends GameState {}

class GameNetworkError extends GameState {}

class GameStarted extends GameState {}

class GameLobbyLoaded extends GameState {
  final List<DiceUser> users;
  GameLobbyLoaded({required this.users});

  GameLobbyLoaded.fromMessage(LobbyUpdate message) :
    users = message.users ?? [];
    

  GameLobbyLoaded copyWith(LobbyUpdate update) {
    return GameLobbyLoaded(
      users: update.users ?? users
    );
  }

  @override
  List<Object> get props => [users];
}
