import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'gamerules_event.dart';
part 'gamerules_state.dart';

class GameRulesBloc extends Bloc<GameRulesEvent, GameRulesState> {
  GameRulesBloc() : super(GameRulesInitial()) {
    on<GameRulesEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
