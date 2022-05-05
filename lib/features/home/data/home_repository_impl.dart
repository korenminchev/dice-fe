import 'package:dice_fe/core/data/cookie_manager.dart';
import 'package:dice_fe/core/data/dice_backend.dart';
import 'package:dice_fe/features/home/domain/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final DiceBackend _backend;
  final CookieManager _cookieManager;

  HomeRepositoryImpl(this._backend, this._cookieManager);
  
  @override
  bool isUserLoggedIn() {
    String userId = _cookieManager.getCookie('user_id');
    if (userId.isNotEmpty) {
      _backend.init(userId);
      return true;
    }
    return false;
  }
}
