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
