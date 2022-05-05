import 'package:dice_fe/core/widgets/app_bar_title.dart';
import 'package:dice_fe/core/widgets/primary_button.dart';
import 'package:dice_fe/core/widgets/text_field.dart';
import 'package:dice_fe/features/create_user/app/bloc/createuser_bloc.dart';
import 'package:dice_fe/features/create_user/domain/user_createtion_repository.dart';
import 'package:dice_fe/features/home/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  static const String routeName = "/create_user";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DiceAppBarTitle(),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => CreateUserBloc(
            serviceLocator<UserCreationRepository>()
          ),
          child: buildCreateUserPage(context),
        ),
      ),
    );
  }

  Widget buildCreateUserPage(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    return BlocConsumer<CreateUserBloc, CreateUserState>(
      listener: (context, state) {
        if (state is UserCreated) {
          Navigator.pop(context);
        }
        if (state is CreateUserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error creating user"),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CreateUserLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Welcome!\nPlease enter your name:",
                style: TextStyle(
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              DiceTextField(
                hintText: "Username...",
                controller: nameController,
                onChanged: (name) {
                  BlocProvider.of<CreateUserBloc>(context).add(
                    LetterTyped(name: name)
                  );
                },
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: "Confirm",
                onTap: state.nameValid
                  ? () {
                    BlocProvider.of<CreateUserBloc>(context).add(
                      CreateUserAction(name: nameController.text),
                    );
                  }
                  : null,
              )
            ]
          )
        );
      }
    );
  }

}