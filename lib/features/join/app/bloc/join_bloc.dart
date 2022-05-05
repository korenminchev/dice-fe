import 'package:bloc/bloc.dart';
import 'package:dice_fe/features/join/domain/join_repository.dart';
import 'package:meta/meta.dart';

part 'join_event.dart';
part 'join_state.dart';

class JoinBloc extends Bloc<JoinEvent, JoinState> {
  JoinRepository _joinRepository;

  JoinBloc(this._joinRepository) : super(JoinInitial()) {
    on<JoinEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<TypingEvent>(_onTypingEvent);
  }

  void _onTypingEvent(TypingEvent event, Emitter<JoinState> emit) async {
    final codeValid = await _joinRepository.isRoomCodeValid(event.roomCodeTyped);
    codeValid.fold(
      (failure) => emit(JoinInitial()),
      (isRoomCodeJoinable) => isRoomCodeJoinable
          ? emit(const JoinAllowed())
          : emit(JoinInitial()),
    );
  }
}
