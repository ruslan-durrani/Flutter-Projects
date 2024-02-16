// ignore: depend_on_referenced_packages
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpState()) {
    on<LoginNowButtonClickedEvent>(loginNowButtonClickedEvent);
    on<RegisterButtonClickedLoadingEvent>(registerButtonClickedLoadingEvent);
    on<RegisterButtonClickedErrorEvent>(registerButtonClickedErrorEvent);

    on<NavigateToEmailVerificationEvent>(navigateToEmailVerificationEvent);
  }

  FutureOr<void> navigateToEmailVerificationEvent(
      NavigateToEmailVerificationEvent event, Emitter<SignUpState> emit) {
    emit(NavigateToEmailVerificationState(event.userCredential));
  }

  FutureOr<void> loginNowButtonClickedEvent(
      LoginNowButtonClickedEvent event, Emitter<SignUpState> emit) {
    emit(LoginNowButtonClickedState());
  }

  FutureOr<void> registerButtonClickedLoadingEvent(
      RegisterButtonClickedLoadingEvent event, Emitter<SignUpState> emit) {
    emit(RegisterButtonClickedLoadingState());
  }

  FutureOr<void> registerButtonClickedErrorEvent(
      RegisterButtonClickedErrorEvent event, Emitter<SignUpState> emit) {
    emit(RegisterButtonErrorState(event.errorMsg));
  }
}
