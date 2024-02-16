part of 'user_preference_bloc.dart';

sealed class UserPreferenceState extends Equatable {
  const UserPreferenceState();

  @override
  List<Object> get props => [];
}

final class UserPreferenceInitial extends UserPreferenceState {}

final class UserPreferenceActionState extends UserPreferenceState {}

final class DarkModeButtonClickedState extends UserPreferenceActionState {}

final class ButtonReleasedState extends UserPreferenceActionState {}

final class RadioButtonClickedLoadingState extends UserPreferenceState {}

final class RadioButtonClickedLoadedState extends UserPreferenceState {
  final int value;

  const RadioButtonClickedLoadedState(this.value);
}
