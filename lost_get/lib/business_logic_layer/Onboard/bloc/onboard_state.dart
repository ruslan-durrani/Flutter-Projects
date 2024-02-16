part of 'onboard_bloc.dart';

class OnboardState {
  int page;
  OnboardState({this.page = 0});
}

class OnboardActionState extends OnboardState {}

class GetStartedButtonClickedActionState extends OnboardActionState {}

class ChangePageDotIndicatorState extends OnboardState {}
