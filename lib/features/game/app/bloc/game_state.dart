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
  final bool readyLoading;
  final String? error;
  GameLobbyLoaded({required this.users, required this.rules, this.userReady = false, this.readyLoading = false, this.error});

  GameLobbyLoaded.fromMessage(LobbyUpdate message, DiceUser currentUser) :
    users = message.players ?? [],
    rules = message.rules!,
    userReady = (message.players!.firstWhere((player) => player.id == currentUser.id)).ready!,
    readyLoading = false,
    error = null
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
    bool? readyLoading,
    String? error,
  }) {
    return GameLobbyLoaded(
      users: users ?? this.users,
      rules: rules ?? this.rules,
      userReady: userReady ?? this.userReady,
      readyLoading: readyLoading ?? this.readyLoading,
      error: error,
    );
  }

  @override
  List<Object> get props => [users, rules, userReady, readyLoading];
}
