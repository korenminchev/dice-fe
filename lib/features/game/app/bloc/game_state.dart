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
  final bool userReady;
  GameLobbyLoaded({required this.users, required this.rules, this.userReady = false});

  GameLobbyLoaded.fromMessage(LobbyUpdate message) :
    users = message.players ?? [],
    rules = message.rules!,
    userReady = false
    ;

  GameLobbyLoaded update(LobbyUpdate update) {
    return GameLobbyLoaded(
      users: update.players ?? users,
      rules: rules.update(rules),
    );
  }

  GameLobbyLoaded copyWith({
    List<DiceUser>? users,
    GameRules? rules,
    bool? userReady,
  }) {
    return GameLobbyLoaded(
      users: users ?? this.users,
      rules: rules ?? this.rules,
      userReady: userReady ?? this.userReady,
    );
  }


  @override
  List<Object> get props => [users, rules, userReady];
}
