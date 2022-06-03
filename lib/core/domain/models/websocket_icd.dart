import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'websocket_icd.g.dart';

enum Event {
  gameStart,
  lobbyUpdate,
  none
}

Map<String, Event> eventMap = {
  "game_start": Event.gameStart,
  "lobby_update": Event.lobbyUpdate
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

@JsonSerializable(explicitToJson: true)
class LobbyUpdate extends Message {
  LobbyUpdate(this.users) : super(Event.lobbyUpdate);
  List<DiceUser>? users;

  factory LobbyUpdate.fromJson(Map<String, dynamic> json) => _$LobbyUpdateFromJson(json);
  toJson() => _$LobbyUpdateToJson(this);
}
