import 'package:json_annotation/json_annotation.dart';

part 'game_rules.g.dart';

@JsonSerializable(explicitToJson: true)
class GameRules {
  @JsonKey(name: 'initial_dice_count')
  int? initialDiceCount;
  @JsonKey(name: 'paso_allowed')
  bool? pasoAllowed;
  @JsonKey(name: 'exact_allowed')
  bool? exactAllowed;

  GameRules({
    required int initialDiceCount,
    required bool pasoAllowed,
    required bool exactAllowed,
  }) : initialDiceCount = initialDiceCount,
       pasoAllowed = pasoAllowed,
       exactAllowed = exactAllowed;

  GameRules update(GameRules rules) {
    return GameRules(
      initialDiceCount: rules.initialDiceCount ?? initialDiceCount!,
      pasoAllowed: rules.pasoAllowed ?? pasoAllowed!,
      exactAllowed: rules.exactAllowed ?? exactAllowed!
    );
  }

  factory GameRules.fromJson(Map<String, dynamic> json) => _$GameRulesFromJson(json);
  Map<String, dynamic> toJson() => _$GameRulesToJson(this);
}