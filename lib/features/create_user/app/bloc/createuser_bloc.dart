import 'package:bloc/bloc.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/features/create_user/domain/user_createtion_repository.dart';
import 'package:meta/meta.dart';

part 'createuser_event.dart';
part 'createuser_state.dart';

class CreateUserBloc extends Bloc<CreateUserEvent, CreateUserState> {
  final UserCreationRepository _userCreationRepository;

  CreateUserBloc(this._userCreationRepository) : super(CreateUserInitial()) {
    on<LetterTyped>(_onLetterTyped);
    on<CreateUserAction>(_onCreateUserAction);
  }

  void _onLetterTyped(LetterTyped event, Emitter<CreateUserState> emit) {
    if (event.name.length > 1) {
      emit(const ValidName());
    } else {
      emit(InvalidName());
    }
  }

  void _onCreateUserAction(CreateUserAction event, Emitter<CreateUserState> emit) async {
    emit(CreateUserLoading());
    final result = await _userCreationRepository.createUser(event.name);
    result.fold(
      (failure) => emit(const CreateUserFailure()),
      (user) => emit(UserCreated(user)),
    );
  }
}
