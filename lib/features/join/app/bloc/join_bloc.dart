import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'join_event.dart';
part 'join_state.dart';

class JoinBloc extends Bloc<JoinEvent, JoinState> {
  JoinBloc() : super(JoinInitial()) {
    on<JoinEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
