import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:json_annotation/json_annotation.dart';

part 'websocket_icd.g.dart';

enum Event {
  gameStart,
  lobbyUpdate,
  none
}

Map<String, Event> eventMap = {
  "game_start": Event.gameStart,
  "game_update": Event.lobbyUpdate
};

class Message {
  final Event messageType;
  const Message(this.messageType);

  factory Message.fromJson(Map<String, dynamic> json) {
    switch (eventMap[json['event']]) {
      case Event.gameStart:
        return GameStart();
      case Event.lobbyUpdate:
        return LobbyUpdate.fromJson(json);
      default:
        return const Message(Event.none);    
    }
  }
}

class GameStart extends Message {
  GameStart() : super(Event.gameStart);
}

_usersFromJson(Map<String, dynamic> json) {

  return json.keys.map((userId) {
    String id = userId;
    String name = json[id]['name'];
    return DiceUser(id: id, name: name);
  }).toList();
}

@JsonSerializable(explicitToJson: true)
class LobbyUpdate extends Message {
  LobbyUpdate(this.players, this.rules) : super(Event.lobbyUpdate);
  @JsonKey(fromJson: _usersFromJson)
  List<DiceUser>? players;
  
  GameRules? rules;

  factory LobbyUpdate.fromJson(Map<String, dynamic> json) => _$LobbyUpdateFromJson(json);
  toJson() => _$LobbyUpdateToJson(this);
}
