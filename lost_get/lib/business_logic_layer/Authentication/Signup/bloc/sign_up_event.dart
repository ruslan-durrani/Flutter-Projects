part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

class NavigateToEmailVerificationEvent extends SignUpEvent {
  final UserCredential userCredential;

  NavigateToEmailVerificationEvent(this.userCredential);
}

class LoginNowButtonClickedEvent extends SignUpEvent {}

class RegisterButtonClickedErrorEvent extends SignUpEvent {
  final String errorMsg;

  RegisterButtonClickedErrorEvent(this.errorMsg);
}

class RegisterButtonClickedLoadingEvent extends SignUpEvent {}
