part of 'user_preference_bloc.dart';

sealed class UserPreferenceEvent extends Equatable {
  const UserPreferenceEvent();

  @override
  List<Object> get props => [];
}

final class DarkModeButtonClickedEvent extends UserPreferenceEvent {}

final class ButtonReleasedEvent extends UserPreferenceEvent {}

final class RadioButtonClickedLoadingEvent extends UserPreferenceEvent {}

final class RadioButtonClickedLoadedEvent extends UserPreferenceEvent {
  final int value;

  const RadioButtonClickedLoadedEvent(this.value);
}
