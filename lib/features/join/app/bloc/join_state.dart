part of 'join_bloc.dart';

@immutable
abstract class JoinState {
  final bool joinAllowed;
  const JoinState({this.joinAllowed = false});
}

class JoinInitial extends JoinState {}

class JoinAllowed extends JoinState {
  const JoinAllowed() : super(joinAllowed: true);
}

class JoinFailureState extends JoinState {
  final String errorMessage;

  const JoinFailureState({this.errorMessage = 'Join failed due to an unknown error'});
}

class JoinSuccess extends JoinState {
  final String roomCode;

  const JoinSuccess({required this.roomCode});
}

class JoinLoading extends JoinState {
  const JoinLoading();
}
