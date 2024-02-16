part of 'profile_settings_bloc.dart';

@immutable
sealed class ProfileSettingsEvent {}

class EditProfileButtonClickedEvent extends ProfileSettingsEvent {}

class SignOutEvent extends ProfileSettingsEvent {}

class SignOutAlertDialogEvent extends ProfileSettingsEvent {}

class SettingsButtonClickedEvent extends ProfileSettingsEvent {}

final class UserProfileLoadingEvent extends ProfileSettingsEvent {}
