import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'createuser_event.dart';
part 'createuser_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  CreateUserBloc() : super(CreateUserInitial()) {
    on<LetterTyped>(_onLetterTyped);
    on<CreateUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  void _onLetterTyped(LetterTyped event, Emitter<CreateUserState> emit) {
    if (event.name.length > 1) {
      emit(const ValidName());
    } else {
      emit(InvalidName());
    }
  }
}
