part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

class EmailOnChangedEvent extends SignInEvent {
  final String email;

  EmailOnChangedEvent({required this.email});
}

class PasswordOnChangedEvent extends SignInEvent {
  final String password;

  PasswordOnChangedEvent({required this.password});
}

class RegisterButtonClickedEvent extends SignInEvent {}

class EyeToggleViewClickedEvent extends SignInEvent {}

class LoginButtonErrorEvent extends SignInEvent {
  final String message;

  LoginButtonErrorEvent(this.message);
}

class LoginButtonLoadingEvent extends SignInEvent {}

class LoginButtonSuccessEvent extends SignInEvent {}
