part of 'settings_bloc.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

final class SettingsInitial extends SettingsState {}

final class SettingsActionState extends SettingsState {}

final class UserPreferenceButtonClickedState extends SettingsActionState {}

final class ReleasedButtonState extends SettingsActionState {}

final class ManageAccountButtonClickedState extends SettingsActionState {}
