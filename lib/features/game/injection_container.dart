import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/game/app/bloc/game_bloc.dart';
import 'package:dice_fe/features/game/data/game_repository_impl.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator =  GetIt.instance;

void initGame() {
  serviceLocator.registerFactory<GameBloc>(
    () => GameBloc(serviceLocator<GameRepository>()));

  serviceLocator.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(serviceLocator<DiceBackend>()));
}
