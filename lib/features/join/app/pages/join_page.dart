import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/drawer/dice_drawer.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/core/widgets/text_field.dart';
import 'package:dice_fe/features/join/app/bloc/join_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({Key? key}) : super(key: key);

  static const String routeName = "/join";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DiceDrawer(),
      appBar: AppBar(
        title: const DiceAppBarTitle(),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => JoinBloc(),
          child: buildJoinPage(context),
        ),
      ),
    );
  }

  Widget buildJoinPage(BuildContext context) {
    return BlocConsumer<JoinBloc, JoinState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Join Game",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
              const SizedBox(height: 40),
              DiceTextField(
                textAlign: TextAlign.center,
                textInputFormatters: [
                  LengthLimitingTextInputFormatter(4),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                ],
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: "Join Game",
                onTap: () {print("Pressed");}
              ),
              const SizedBox(height: 40),
              const Text(
                "Friends Active Games",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700))
            ],
          ),
        );
      }
    );
  }
}
