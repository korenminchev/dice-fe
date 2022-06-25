import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/app_ui.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/core/widgets/text_field.dart';
import 'package:dice_fe/features/join/app/bloc/join_bloc.dart';
import 'package:dice_fe/features/join/domain/join_repository.dart';
import 'package:dice_fe/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({Key? key}) : super(key: key);

  static const String routeName = "/join";

  @override
  Widget build(BuildContext context) {
    AppUI.setUntitsSize(context);
    return Scaffold(
      drawer: const DiceDrawer(),
      appBar: AppBar(
        title: const DiceAppBarTitle(),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => JoinBloc(serviceLocator<JoinRepository>()),
          child: buildJoinPage(context),
        ),
      ),
    );
  }

  Widget buildJoinPage(BuildContext context) {
    TextEditingController _joinRoomCodeController = TextEditingController();
    return BlocConsumer<JoinBloc, JoinState>(
      listener: (context, state) {
        if (state is JoinSuccess) {
          Navigator.of(context).pushReplacementNamed('/game/${state.roomCode}');
        }
      },
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              SizedBox(height: 2 * AppUI.heightUnit),
              const Text(
                "Join Game",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
              SizedBox(height: 5 * AppUI.heightUnit),
              DiceTextField(
                textAlign: TextAlign.center,
                textInputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
                controller: _joinRoomCodeController,
                onChanged: (roomCode) {
                  BlocProvider.of<JoinBloc>(context).add(TypingEvent(roomCode));
                },
                keyboardType: TextInputType.number,
              ),
              if (state is! JoinFailureState)
                SizedBox(height: 6 * AppUI.heightUnit),
              if (state is JoinFailureState)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.8 * AppUI.heightUnit),
                  child: Text(
                    state.errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              if (state is JoinLoading) 
                const CircularProgressIndicator.adaptive(),
              if (state is! JoinLoading)
                PrimaryButton(
                  text: "Join Game",
                  onTap: state.joinAllowed 
                    ? () => BlocProvider.of<JoinBloc>(context).add(
                      JoinRequestEvent(
                        roomCode: _joinRoomCodeController.text,
                        joinAllowed: true
                      )) 
                    : null,
                ),
            ],
          ),
        );
      }
    );
  }
}
