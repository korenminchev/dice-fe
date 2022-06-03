import 'package:bloc/bloc.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;

  GameBloc(this._gameRepository) : super(GameInitial()) {
    on<CheckCodeValidity>(_onCheckCodeValidity);
  }

  void _onCheckCodeValidity(CheckCodeValidity event, Emitter<GameState> emit) async {
    final isRoomCodeValid = await _gameRepository.isRoomCodeValid(event.roomCode);
    isRoomCodeValid.fold(
      (failure) => emit(GameRoomCodeInvalid()),
      (joinable) => emit(joinable ? GameLobbyLoading() : GameRoomCodeInvalid())
    );
  }
}
