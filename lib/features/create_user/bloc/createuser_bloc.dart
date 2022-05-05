import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'createuser_event.dart';
part 'createuser_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  CreateUserBloc() : super(CreateUserInitial()) {
    on<CreateUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
