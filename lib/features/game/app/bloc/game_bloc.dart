import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/game_rules.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
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
    on<AccusationEvent>(_onAccusation);
  }

  void _onVerifyParams(VerifyParams event, Emitter<GameState> emit) async {
    bool codeValid = false;
    // Check if user is logged in
    final logedInResult = await _gameRepository.isUserLoggedIn();
    logedInResult.fold(
      (failure) async {
        emit(GameUserNotLoggedIn());
        return;
      },
      (user) {
        _user = user;
      },
    );


    // Check room code is valid
    final isRoomCodeValid = await _gameRepository.isRoomCodeValid(event.roomCode, _user.id);
    isRoomCodeValid.fold(
      (failure) => emit(GameRoomCodeInvalid()),
      (joinable) {
        if (joinable) {
            add(JoinGame(event.roomCode, _user));
        }
        else {
          emit(GameRoomCodeInvalid());
        }
      }
    );
  }

  void _onExitGame(ExitGame event, Emitter<GameState> emit) {
    _gameRepository.sendMessage(PlayerLeave());
    _gameRepository.exit();
  }

  void _joinGame(JoinGame event, Emitter<GameState> emit) async{
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

  void _onAccusation(AccusationEvent event, Emitter<GameState> emit) {
    _gameRepository.sendMessage(Accusation(
      accusedPlayer: event.accusedUser.id,
      type: event.type,
      diceCount: event.diceCount,
      diceValue: event.diceValue
    ));
  }

  void handleBackendStream(StreamStarted event, Emitter<GameState> emit) async {
    await emit.onEach(
      _websocketStream,
      onData: (message) {
        switch ((message as Message).messageType) {
          case Event.gameStart:
            print("GameReady from message");
            emit(GameReady.fromMessage(message as GameStart, _user));
            break;

          case Event.roundStart:
            print("GameReady update dice");
            emit((state as GameReady).updateDice(message as RoundStart));
            break;

          case Event.roundEnd:
            GameReady currentState = state as GameReady;
            print("Round end state");
            emit(RoundEndState(message as RoundEnd));
            print("Return game state");
            emit(currentState);
            break;

          case Event.lobbyUpdate:
            message = message as LobbyUpdate;
            if (state is GameLobbyReady) {
              print("LobbyUpdate update");
              emit((state as GameLobbyReady).update(message));
              return;
            }

            if (state is GameReady) {
              print("GameReady update");
              emit((state as GameReady).update(message));
              return;
            }

            else {
              if (message.progression == GameProgression.inGame) {
                emit(GameReady(
                  _user,
                  message.rules!,
                  message.players,
                  const [],
                ));
                return;
              }
              print("LobbyUpdate from message");
              emit(GameLobbyReady.fromMessage(message, _user));
              return;
            }

          case Event.readyConfirmation:
            message as ReadyConfirmation;
            emit((state as GameLobbyReady).copyWith(
              readyLoading: false,
              userReady: message.success,
              error: message.error
            ));
            break;

          default:
            print("Unknown message type");
            break;
        }
      }
    );
  }

  void _onReady(ReadyEvent event, Emitter<GameState> emit) {
    _gameRepository.sendMessage(PlayerReady(event.isReady, event.userOnLeft.id, event.userOnRight.id));
    if (event.isReady) {
      emit((state as GameLobbyReady).copyWith(readyLoading: true));
    }
    else {
      emit((state as GameLobbyReady).copyWith(userReady: false));
    }
  }
}
