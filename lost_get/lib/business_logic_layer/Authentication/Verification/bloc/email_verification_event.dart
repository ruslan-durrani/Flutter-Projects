part of 'email_verification_bloc.dart';

@immutable
sealed class EmailVerificationEvent {}

class CountDownTimerEvent extends EmailVerificationEvent {
  final int remainingSeconds;

  CountDownTimerEvent(this.remainingSeconds);
}

class ResendVerificationEmailClickedEvent extends EmailVerificationEvent {}

class EmailVerifiedEvent extends EmailVerificationEvent {}
