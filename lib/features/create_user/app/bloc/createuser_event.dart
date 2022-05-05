part of 'createuser_bloc.dart';

@immutable
abstract class CreateUserEvent {}

class CreateUserAction extends CreateUserEvent {
  final String name;

  CreateUserAction({required this.name});
}

class LetterTyped extends CreateUserEvent {
  final String name;

  LetterTyped({required this.name});
}