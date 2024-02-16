import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'email_verification_event.dart';
part 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<CountDownTimerEvent>(countDownTimerEvent);
    on<ResendVerificationEmailClickedEvent>(
        resendVerificationEmailClickedEvent);
    on<EmailVerifiedEvent>(emailVerifiedEvent);
  }

  FutureOr<void> countDownTimerEvent(
      CountDownTimerEvent event, Emitter<EmailVerificationState> emit) {
    emit(CountDownTimerState(event.remainingSeconds));
  }

  FutureOr<void> resendVerificationEmailClickedEvent(
      event, Emitter<EmailVerificationState> emit) {
    emit(ResendVerificationEmailClickedState());
  }

  FutureOr<void> emailVerifiedEvent(
      EmailVerifiedEvent event, Emitter<EmailVerificationState> emit) {
    emit(EmailVerifiedState());
  }
}
