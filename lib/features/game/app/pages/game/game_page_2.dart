import 'package:dice_fe/features/game/app/pages/game/game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

// class GamePage extends View {
//   final String routeName = '/game';
//   final String roomCode;

//   GamePage({required this.roomCode, Key? key}) : super(key: key); 

//   @override
//   // ignore: no_logic_in_create_state
//   State<GamePage> createState() => GamePageState(roomCode);
// }

// class GamePageState extends ViewState<GamePage, GameController> {
//   String roomCode;
//   GamePageState(this.roomCode) : super(GameController(roomCode, serviceLocator<GameRepository>()));

//   @override
//   Widget get view {
//     return 
//   }