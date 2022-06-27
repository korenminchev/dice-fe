import 'package:dice_fe/core/domain/version.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/features/create_game/create_game_page.dart';
import 'package:dice_fe/features/create_user/app/pages/create_user_page.dart';
import 'package:dice_fe/features/game/app/pages/game_page.dart';
import 'package:dice_fe/features/home/pages/home_page.dart';
import 'package:dice_fe/features/join/app/pages/join_page.dart';
import 'package:dice_fe/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  init();
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({Key? key}) : super(key: key);

  void initVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    Version.set(info.version);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    initVersion();
    return MaterialApp(
      title: 'Dice',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.comfortable,
      ),
      initialRoute: HomePage.routeName,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == HomePage.routeName) {
              return const HomePage();
            } else if (settings.name == JoinPage.routeName) {
              return const JoinPage();
            } else if (settings.name == CreateUserPage.routeName) {
              return const CreateUserPage();
            } else if (settings.name == CreateGamePage.route) {
              return const CreateGamePage();
            } else if (settings.name!.startsWith(GamePage.routeName)) {
              final roomCode = settings.name!.split('/').last;
              if (!RegExp(r'^[0-9]+$').hasMatch(roomCode)) {
                return const Scaffold(
                  body: Center(
                    child: Text('Invalid room code'),
                  ),
                );
              }
              return GamePage(roomCode: roomCode);
            }
            
            return const Scaffold(
              body: Center(
                child: Text('404'),
              ),
            );
          }
        );
      },
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: "Lato",
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        visualDensity: const VisualDensity(horizontal: -2, vertical: -2)
      ),
    );
  }
}
