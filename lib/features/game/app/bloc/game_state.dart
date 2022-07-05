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

class GameReady extends GameState {
  final DiceUser currentUser;
  final GameRules rules;
  final List<DiceUser> players;
  final List<int> dice;

  GameReady(this.currentUser, this.rules, this.players, this.dice);

  GameReady.fromMessage(GameStart message, this.currentUser)
      : rules = message.rules,
        players = [],
        dice = [];

  GameReady update(LobbyUpdate message) {
    List<DiceUser> newPlayers;
    if (players.isEmpty) {
      newPlayers = message.players;
    } else {
      newPlayers = message.players.isEmpty ? players : 
        message.players.map((p) => p.update(players.firstWhere((op) => op.id == p.id))).toList();     
    }
    return GameReady(
      currentUser,
      rules,
      newPlayers,
      dice,
    );
  }

  GameState updateDice(RoundStart message) {
    return GameReady(
      currentUser,
      rules,
      players,
      message.dice,
    );
  }

  @override
  List<Object> get props => [currentUser, rules, players, dice];
}

class GameLobbyReady extends GameState {
  final List<DiceUser> users;
  final GameRules rules;
  final bool userReady;
  final bool readyLoading;
  final String? error;
  GameLobbyReady({required this.users, required this.rules, this.userReady = false, this.readyLoading = false, this.error});

  GameLobbyReady.fromMessage(LobbyUpdate message, DiceUser currentUser) :
    users = message.players,
    rules = message.rules!,
    userReady = (message.players.firstWhere((player) => player.id == currentUser.id)).ready!,
    readyLoading = false,
    error = null
    ;

  GameLobbyReady update(LobbyUpdate update) {
    return GameLobbyReady(
      users: update.players,
      rules: rules.update(rules),
      readyLoading: readyLoading,
      userReady: userReady,
      error: error
    );
  }

  GameLobbyReady copyWith({
    List<DiceUser>? users,
    GameRules? rules,
    bool? userReady,
    bool? readyLoading,
    String? error,
  }) {
    return GameLobbyReady(
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

class RoundEndState extends GameState {
  final RoundEnd roundEnd;

  RoundEndState(this.roundEnd);

  @override
  List<Object> get props => [roundEnd];
}