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
    on<CheckCodeValidity>(_onCheckCodeValidity);
    on<StreamStarted>(handleBackendStream);
  }

  void _onCheckCodeValidity(CheckCodeValidity event, Emitter<GameState> emit) async {
    final logedInResult = _gameRepository.isUserLoggedIn();
    logedInResult.fold(
      (failure) {
        emit(GameUserNotLoggedIn());
        // Wait here for user name
      },
      (user) => _user = user,
    );
    final isRoomCodeValid = await _gameRepository.isRoomCodeValid(event.roomCode);
    isRoomCodeValid.fold(
      (failure) => emit(GameRoomCodeInvalid()),
      (joinable) {
        if (joinable) {
          loadLobby(event.roomCode, emit);
        }
        else {
          emit(GameRoomCodeInvalid());
        }
      }
    );
  }

  void loadLobby(String roomCode, Emitter<GameState> emit) async{
    emit(GameLobbyLoading(_user));
    final streamResult = await _gameRepository.joinRoom(roomCode);
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
            emit((state as GameLobbyLoaded).copyWith(message));
          }
          else {
            emit(GameLobbyLoaded.fromMessage(message));
          }
        }
      }
    );
  }
}
