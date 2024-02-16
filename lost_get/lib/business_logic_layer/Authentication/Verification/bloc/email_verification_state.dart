part of 'email_verification_bloc.dart';

@immutable
sealed class EmailVerificationState {}

final class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationActionState extends EmailVerificationState {}

class CountDownTimerState extends EmailVerificationState {
  final int remainingSeconds;

  CountDownTimerState(this.remainingSeconds);
}

class ResendVerificationEmailClickedState
    extends EmailVerificationActionState {}

class EmailVerifiedState extends EmailVerificationActionState {}
