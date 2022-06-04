import 'package:dice_fe/core/data/authorization_repository_impl.dart';
import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/core/domain/authorization_repository.dart';
import 'package:dice_fe/features/create_user/injection_container.dart';
import 'package:dice_fe/features/game/injection_container.dart';
import 'package:dice_fe/features/home/injection_container.dart';
import 'package:dice_fe/features/join/injection_container.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  serviceLocator.registerLazySingleton<DiceBackend>(
    () => DiceBackend(),
  );

  serviceLocator.registerLazySingleton<CookieManager>(
    () => CookieManager(),
  );

  serviceLocator.registerLazySingleton<AuthorizationRepository>(
    () => AuthorizationRepositoryImpl(
      serviceLocator<DiceBackend>(),
      serviceLocator<CookieManager>(),
    ),
  );

  initHome();
  initCreateUser();
  initJoin();
  initGame();
}