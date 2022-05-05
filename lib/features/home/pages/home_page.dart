import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/features/home/domain/home_repository.dart';
import 'package:dice_fe/features/join/app/pages/join_page.dart';
import 'package:dice_fe/features/join/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:dice_fe/features/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DiceDrawer(),
      appBar: AppBar(),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => HomeBloc(serviceLocator<HomeRepository>()),
          child: buildHomePage(context),
        ),
      ),
    );
  }

  Widget buildHomePage(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(listener: ((context, state) {
      if (state is NavigateJoinGame) {
        if (state.isUserLoggedIn) {
          Navigator.of(context).pushNamed(JoinPage.routeName);
        } else {
          // Navigator.of(context).pushNamed(LoginPage.routeName);
          print("Name screen");
        }
      } else if (state is NavigateCreateGame) {
        // Navigator.of(context).pushNamed('/create');
      } else if (state is NavigateGameRules) {
        // Navigator.of(context).pushNamed('/game_rules');
      }
    }), builder: (context, state) {
      return Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 32),
            const Text(
              "Dice",
              style: TextStyle(fontFamily: "Hurricane", fontSize: 96),
            ),
            SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/dice_logo.png")),
            const SizedBox(height: 56),
            PrimaryButton(
              text: 'Join Game',
              onTap: () {
                BlocProvider.of<HomeBloc>(context).add(JoinGame());
              },
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Create Game',
              onTap: () {
                BlocProvider.of<HomeBloc>(context).add(CreateGame());
              },
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                BlocProvider.of<HomeBloc>(context).add(GameRules());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Game rules",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  // Icon(Icons.chevron_right)
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
