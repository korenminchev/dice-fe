import 'package:flutter/material.dart';

class GamePage extends StatelessWidget {
  final String roomCode;
  const GamePage({ 
    required this.roomCode,
    Key? key }) : super(key: key);

  static const String routeName = "/game";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Game Page - Room $roomCode'),
      ),
    );
  }
}