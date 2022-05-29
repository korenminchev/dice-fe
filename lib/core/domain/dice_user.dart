
import 'package:json_annotation/json_annotation.dart';

part 'dice_user.g.dart';

const String userCookieRecordName = 'dice_user';

@JsonSerializable()
class DiceUser {
  final String id;
  final String name;

  DiceUser({required this.id, required this.name});

  factory DiceUser.fromJson(Map<String, dynamic> json) => _$DiceUserFromJson(json);
  toJson() => _$DiceUserToJson(this);
}
