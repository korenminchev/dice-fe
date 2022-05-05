import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/join/app/bloc/join_bloc.dart';
import 'package:dice_fe/features/join/data/join_repository_impl.dart';
import 'package:dice_fe/features/join/domain/join_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator =  GetIt.instance;

void initJoin() {
  serviceLocator.registerFactory<JoinBloc>(
    () => JoinBloc(serviceLocator<JoinRepository>())
  );

  serviceLocator.registerLazySingleton<JoinRepository>(
    () => JoinRepositoryImpl(serviceLocator<DiceBackend>())
  );
}