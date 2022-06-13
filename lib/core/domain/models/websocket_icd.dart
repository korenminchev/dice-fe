import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:json_annotation/json_annotation.dart';

part 'websocket_icd.g.dart';

enum Event {
  gameStart,
  roundStart,
  lobbyUpdate,
  playerReady,
  playerLeave,
  readyConfirmation,
  none
}

Map<String, Event> incomingEventMap = {
  "round_start" : Event.roundStart,
  "game_start": Event.gameStart,
  "game_update": Event.lobbyUpdate,
  "ready_confirm": Event.readyConfirmation
};

Map<Event, String> outgoingEventMap = {
  Event.playerReady: "player_ready",
  Event.playerLeave: "player_leave",
};

abstract class Message {
  final Event messageType;
  const Message(this.messageType);

  factory Message.fromJson(Map<String, dynamic> json) {
    switch (incomingEventMap[json['event']]) {
      case Event.gameStart:
        return GameStart.fromJson(json);
      case Event.roundStart:
        return RoundStart.fromJson(json);
      case Event.lobbyUpdate:
        return LobbyUpdate.fromJson(json);
      case Event.readyConfirmation:
        return ReadyConfirmation.fromJson(json);
      default:
        return LobbyUpdate();
    }
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class GameStart extends Message {
  GameStart(this.rules) : super(Event.gameStart);
  GameRules rules;

  factory GameStart.fromJson(Map<String, dynamic> json) => _$GameStartFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GameStartToJson(this);
}

@JsonSerializable()
class RoundStart extends Message {
  RoundStart({this.dice = const []}) : super(Event.none);
  List<int> dice;

  factory RoundStart.fromJson(Map<String, dynamic> json) => _$RoundStartFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RoundStartToJson(this);
}

GameProgression? _gameProgressionFromString(String? value) {
  if (value == null) return null;
  return gameProgressionFromString[value]!;
}

@JsonSerializable(explicitToJson: true)
class LobbyUpdate extends Message {
  LobbyUpdate({
    this.players,
    this.rules,
    this.admin,
    this.progression,
  }) : super(Event.lobbyUpdate);
  List<DiceUser>? players;
  GameRules? rules;
  DiceUser? admin;
  List<int>? dice;
  @JsonKey(fromJson: (_gameProgressionFromString))
  GameProgression? progression;

  factory LobbyUpdate.fromJson(Map<String, dynamic> json) => _$LobbyUpdateFromJson(json);
  @override
  toJson() => _$LobbyUpdateToJson(this);
}

@JsonSerializable()
class PlayerLeave extends Message {
  @JsonKey(name: 'event')
  String eventString = "player_leave";
  PlayerLeave() : super(Event.playerLeave);

  factory PlayerLeave.fromJson(Map<String, dynamic> json) => _$PlayerLeaveFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlayerLeaveToJson(this);
}

@JsonSerializable()
class PlayerReady extends Message {
  @JsonKey(name: 'event')
  String eventString = "player_ready";
  bool ready;
  @JsonKey(name: 'left_player_id')
  String playerOnLeftId;
  @JsonKey(name: 'right_player_id')
  String playerOnRightId;

  PlayerReady(
    this.ready,
    this.playerOnLeftId,
    this.playerOnRightId
  ) : super(Event.playerReady);
  

  factory PlayerReady.fromJson(Map<String, dynamic> json) => _$PlayerReadyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlayerReadyToJson(this);
}

@JsonSerializable()
class ReadyConfirmation extends Message {
  @JsonKey(name: 'event')
  String eventString = "ready_confirm";
  bool success;
  String? error;

  ReadyConfirmation(
    this.success,
    this.error
  ) : super(Event.readyConfirmation);

  factory ReadyConfirmation.fromJson(Map<String, dynamic> json) => _$ReadyConfirmationFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ReadyConfirmationToJson(this);
}
