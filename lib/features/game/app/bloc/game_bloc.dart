import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:dice_fe/features/home/bloc/home_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;
  late final Stream _websocketStream;
  late final DiceUser _user;

  GameBloc(this._gameRepository) : super(GameInitial()) {
    on<VerifyParams>(_onVerifyParams);
    on<StreamStarted>(handleBackendStream);
    on<JoinGame>(_joinGame);
    on<ExitGame>(_onExitGame);
    on<ReadyEvent>(_onReady);
  }

  void _onVerifyParams(VerifyParams event, Emitter<GameState> emit) async {
    bool codeValid = false;
    // Check room code is valid
    final isRoomCodeValid = await _gameRepository.isRoomCodeValid(event.roomCode);
    isRoomCodeValid.fold(
      (failure) => emit(GameRoomCodeInvalid()),
      (joinable) {
        if (joinable) {
          codeValid = true;
        }
        else {
          emit(GameRoomCodeInvalid());
        }
      }
    );

    // Check if user is logged in
    final logedInResult = _gameRepository.isUserLoggedIn();
    logedInResult.fold(
      (failure) async {
        emit(GameUserNotLoggedIn());
      },
      (user) {
        if (codeValid) {
          add(JoinGame(event.roomCode, user));
        }
      },
    );
  }

  void _onExitGame(ExitGame event, Emitter<GameState> emit) {
    _gameRepository.sendMessage(PlayerLeave());
    _gameRepository.exit();
  }

  void _joinGame(JoinGame event, Emitter<GameState> emit) async{
    _user = event.user;
    emit(GameLobbyLoading(_user));
    final streamResult = await _gameRepository.joinRoom(event.roomCode);
    streamResult.fold(
      (failure) {
        emit(GameNetworkError());
      },
      (stream) {
        _websocketStream = stream;
        add(StreamStarted());
      }
    );
  }

  void handleBackendStream(StreamStarted event, Emitter<GameState> emit) async {
    await emit.onEach(
      _websocketStream,
      onData: (message) {
        if (message is GameStart) {
          emit(GameStarted());
        }
        else if (message is LobbyUpdate) {
          if (state is GameLobbyLoaded) {
            emit((state as GameLobbyLoaded).update(message));
          }
          else {
            emit(GameLobbyLoaded.fromMessage(message, _user));
          }
        }
        else if (message is ReadyConfirmation) {
          emit((state as GameLobbyLoaded).copyWith(
            readyLoading: false,
            userReady: message.success,
            error: message.error
          ));
        }
      }
    );
  }

  void _onReady(ReadyEvent event, Emitter<GameState> emit) {
    _gameRepository.sendMessage(PlayerReady(event.isReady, event.userOnLeft.id, event.userOnRight.id));
    if (event.isReady) {
      emit((state as GameLobbyLoaded).copyWith(readyLoading: true));
    }
    else {
      emit((state as GameLobbyLoaded).copyWith(userReady: false));
    }
  }
}
