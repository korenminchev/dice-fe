import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<JoinGame>((event, emit) => emit(NavigateJoinGame()));
    on<CreateGame>((event, emit) => emit(NavigateCreateGame()));
    on<GameRules>((event, emit) => emit(NavigateGameRules()));
  }
}
