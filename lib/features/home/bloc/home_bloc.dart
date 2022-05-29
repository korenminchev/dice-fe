import 'package:dice_fe/features/home/domain/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<JoinGame>(_onJoinGame);
    on<CreateGameButton>((event, emit) => emit(NavigateCreateGame(
      _repository.isUserLoggedIn()
    )));
    on<GameRules>((event, emit) => emit(NavigateGameRules()));
    on<CreateGame>(_onCreateGame);
  }

  _onJoinGame(JoinGame event, Emitter<HomeState> emit) {
    emit(NavigateJoinGame(_repository.isUserLoggedIn()));
  }

  _onCreateGame(CreateGame event, Emitter<HomeState> emit) async {
    emit(Loading());
    final result = await _repository.createGame();
    return result.fold(
      (failure) => emit(Error(failure.message)),
      (roomCode) => emit(GameCreated(roomCode))
    );
  }
}
