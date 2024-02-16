import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'user_preference_event.dart';
part 'user_preference_state.dart';

class UserPreferenceBloc
    extends Bloc<UserPreferenceEvent, UserPreferenceState> {
  UserPreferenceBloc() : super(UserPreferenceInitial()) {
    on<DarkModeButtonClickedEvent>(darkModeButtonClickedEvent);
    on<ButtonReleasedEvent>(buttonReleasedEvent);
  }

  FutureOr<void> darkModeButtonClickedEvent(
      DarkModeButtonClickedEvent event, Emitter<UserPreferenceState> emit) {
    emit(DarkModeButtonClickedState());
  }

  FutureOr<void> buttonReleasedEvent(
      ButtonReleasedEvent event, Emitter<UserPreferenceState> emit) {
    emit(ButtonReleasedState());
  }
}
