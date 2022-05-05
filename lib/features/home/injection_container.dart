import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/home/bloc/home_bloc.dart';
import 'package:dice_fe/features/home/data/home_repository_impl.dart';
import 'package:dice_fe/features/home/domain/home_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void initHome() {
  serviceLocator.registerFactory<HomeBloc>(
    () => HomeBloc(serviceLocator<HomeRepository>())
  );

  serviceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      serviceLocator<DiceBackend>(),
      serviceLocator<CookieManager>()
    )
  );
}