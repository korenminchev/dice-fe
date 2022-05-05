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
