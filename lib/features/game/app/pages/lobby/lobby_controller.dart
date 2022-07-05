import 'package:dice_fe/core/data/authorization_repository_impl.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/features/create_user/app/pages/create_user_page.dart';
import 'package:dice_fe/features/game/app/pages/lobby/lobby_presenter.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class LobbyController extends Controller {
  final String roomCode;
  final LobbyPresenter presenter;
  LobbyController(this.roomCode) : presenter = LobbyPresenter(roomCode);

  @override
  void initListeners() {
    presenter.lobbyOnComplete = (user) {
      
    };
    presenter.lobbyOnError = (failure) {
      if (failure is NoUserId) {
        Navigator.of(getContext()).pushNamed(CreateUserPage.routeName);
      }
      if (failure is RoomCodeInvalid) {
        print('Room code invalid');
      }
    };
    presenter.lobbyOnNext = (message) {
      
    };
  }

  


}
