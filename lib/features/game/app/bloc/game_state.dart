// import 'package:dice_fe/core/domain/models/game_rules.dart' as game_rules;

part of 'game_bloc.dart';

@immutable
abstract class GameState extends Equatable {
  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameRoomCodeInvalid extends GameState {}

class GameUserNotLoggedIn extends GameState {}

class GameLobbyLoading extends GameState {
  final DiceUser currentUser;

  GameLobbyLoading(this.currentUser);
}

class GameNetworkError extends GameState {}

class GameStarted extends GameState {}

class GameLobbyLoaded extends GameState {
  final List<DiceUser> users;
  final GameRules rules;
  GameLobbyLoaded({required this.users, required this.rules});

  GameLobbyLoaded.fromMessage(LobbyUpdate message) :
    users = message.players ?? [], rules = message.rules!;
    

  GameLobbyLoaded copyWith(LobbyUpdate update) {
    return GameLobbyLoaded(
      users: update.players ?? users,
      rules: rules.update(rules),
    );
  }

  @override
  List<Object> get props => [users, rules];
}
