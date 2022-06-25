part of 'createuser_bloc.dart';

@immutable
abstract class CreateUserState {
  final bool nameValid;

  const CreateUserState({this.nameValid = false});
}

class CreateUserInitial extends CreateUserState {}

class InvalidName extends CreateUserState {}

class ValidName extends CreateUserState {
  const ValidName() : super(nameValid: true);
}

class CreateUserLoading extends CreateUserState {}

class CreateUserFailure extends CreateUserState {
  const CreateUserFailure() : super(nameValid: true);
}

class UserCreated extends CreateUserState {
  final DiceUser user;

  const UserCreated(this.user);
}
