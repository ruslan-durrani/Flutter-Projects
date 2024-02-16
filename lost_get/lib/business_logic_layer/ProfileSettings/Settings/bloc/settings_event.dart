part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class UserPreferenceButtonClickedEvent extends SettingsEvent {}

final class ReleasedButtonEvent extends SettingsEvent {}

final class ManageAccountButtonClickedEvent extends SettingsEvent {}
