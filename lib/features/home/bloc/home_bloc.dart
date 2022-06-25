import 'package:dice_fe/features/home/domain/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<JoinGame>(((event, emit) => emit(NavigateJoinGame())));
    on<CreateGameButton>((event, emit) => emit(NavigateCreateGame()));
    on<GameRulesEvent>((event, emit) => emit(NavigateGameRules()));
  }
}
