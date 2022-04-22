import 'package:dice_fe/core/drawer/dice_drawer.dart';
import 'package:flutter/material.dart';
import 'package:dice_fe/features/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  static String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DiceDrawer(),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(),
        child: buildHomePage(context),
      ),
    );
  }

  Widget buildHomePage(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: ((context, state) {
        if (state is NavigateJoinGame) {
          print("1");
          // Navigator.of(context).pushNamed('/join_game');
        } else if (state is NavigateCreateGame) {
          print("2");
          // Navigator.of(context).pushNamed('/create_game');
        } else if (state is NavigateGameRules) {
          print("3");
          // Navigator.of(context).pushNamed('/game_rules');
        }
      }),
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: Text('Join Game'),
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(JoinGame());
                },
              ),
              TextButton(
                child: Text('Create Game'),
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(CreateGame());
                },
              ),
              TextButton(
                child: Text('Game Rules'),
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(GameRules());
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
