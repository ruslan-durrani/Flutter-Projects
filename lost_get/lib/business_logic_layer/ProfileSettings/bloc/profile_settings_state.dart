part of 'profile_settings_bloc.dart';

@immutable
sealed class ProfileSettingsState {}

final class ProfileSettingsInitial extends ProfileSettingsState {}

class ProfileSettingsActionState extends ProfileSettingsState {}

class EditProfileButtonClickedState extends ProfileSettingsActionState {}

class SignOutState extends ProfileSettingsState {}

class SignOutLoadingState extends ProfileSettingsActionState {}

class SignOutLoadingSuccessState extends ProfileSettingsActionState {}

class SignOutLoadingErrorState extends ProfileSettingsActionState {}

class SignOutAlertDialogState extends ProfileSettingsActionState {}

class SettingsButtonClickedState extends ProfileSettingsActionState {}

class ViewPoliceStatusButtonClickedState extends ProfileSettingsActionState {}

final class UserProfileLoadingState extends ProfileSettingsState {}

final class UserProfileLoadedState extends ProfileSettingsState {
  final UserProfile userProfile;

  UserProfileLoadedState(this.userProfile);
}

final class UserProfileErrorState extends ProfileSettingsState {
  final String msg;

  UserProfileErrorState(this.msg);
}
