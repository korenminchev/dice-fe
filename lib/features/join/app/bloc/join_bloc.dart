import 'package:bloc/bloc.dart';
import 'package:dice_fe/features/join/domain/join_repository.dart';
import 'package:meta/meta.dart';

part 'join_event.dart';
part 'join_state.dart';

class JoinBloc extends Bloc<JoinEvent, JoinState> {
  final JoinRepository _joinRepository;

  JoinBloc(this._joinRepository) : super(JoinInitial()) {
    on<JoinRequestEvent>(_onJoinRequestEvent);
    on<TypingEvent>(_onTypingEvent);
  }

  void _onTypingEvent(TypingEvent event, Emitter<JoinState> emit) async {
    if (!_joinRepository.isRoomCodeValid(event.roomCodeTyped)) {
      emit(JoinInitial());
      return;
    }

    emit(const JoinLoading());
    final codeValid = await _joinRepository.isRoomCodeJoinable(event.roomCodeTyped);
    codeValid.fold(
      (failure) {
        if (failure is RoomCodeInvalid) {
          emit(const JoinFailureState(errorMessage: "Room code does not exist"));
        }
        else {
          emit(const JoinFailureState());
        }
      },
      (isRoomCodeJoinable) => isRoomCodeJoinable
          ? emit(const JoinAllowed())
          : emit(const JoinFailureState(errorMessage: "Room code does not exist")),
    );
  }

  void _onJoinRequestEvent(JoinRequestEvent event, Emitter<JoinState> emit) async {
    if (!event.joinAllowed) {
      return;
    }
    emit(JoinSuccess(roomCode: event.roomCode));
  }
}
