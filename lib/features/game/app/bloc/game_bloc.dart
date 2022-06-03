import 'package:bloc/bloc.dart';
import 'package:dice_fe/core/domain/dice_user.dart';
import 'package:dice_fe/core/domain/models/websocket_icd.dart';
import 'package:dice_fe/features/game/domain/repositories/game_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameRepository _gameRepository;

  GameBloc(this._gameRepository) : super(GameInitial()) {
    on<CheckCodeValidity>(_onCheckCodeValidity);
  }

  void _onCheckCodeValidity(CheckCodeValidity event, Emitter<GameState> emit) async {
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
    emit(GameLobbyLoading());
    final streamResult = await _gameRepository.joinRoom(roomCode);
    streamResult.fold(
      (failure) => emit(GameNetworkError()),
      (stream) => handleBackendStream(stream, emit)
    );
    
  }

  void handleBackendStream(Stream stream, Emitter<GameState> emit) async {
    stream.listen(
      (message) {
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
      },
      onError: (error) {
        print(error);
      },
    );
  }
}
