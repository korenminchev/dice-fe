import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/create_user/app/bloc/createuser_bloc.dart';
import 'package:dice_fe/features/create_user/data/user_creation_repository_impl.dart';
import 'domain/user_createtion_repository.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void initCreateUser() {
  serviceLocator.registerFactory(
    () => CreateUserBloc(serviceLocator<UserCreationRepository>())
  );

  serviceLocator.registerLazySingleton<UserCreationRepository>(
    () => UserCreationRepositoryImpl(
      serviceLocator<DiceBackend>(), serviceLocator<CookieManager>(),
    )
  );
}