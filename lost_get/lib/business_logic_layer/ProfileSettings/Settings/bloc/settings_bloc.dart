import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<UserPreferenceButtonClickedEvent>(userPreferenceButtonClickedEvent);
    on<ReleasedButtonEvent>(releasedButtonEvent);
    on<ManageAccountButtonClickedEvent>(manageAccountButtonClickedEvent);
  }

  FutureOr<void> userPreferenceButtonClickedEvent(
      UserPreferenceButtonClickedEvent event, Emitter<SettingsState> emit) {
    emit(UserPreferenceButtonClickedState());
  }

  FutureOr<void> releasedButtonEvent(
      ReleasedButtonEvent event, Emitter<SettingsState> emit) {
    emit(ReleasedButtonState());
  }

  FutureOr<void> manageAccountButtonClickedEvent(
      ManageAccountButtonClickedEvent event, Emitter<SettingsState> emit) {
    emit(ManageAccountButtonClickedState());
  }
}
