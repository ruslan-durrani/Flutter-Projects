import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginActionState()) {
    on<LoginEmailOnChangeEvent>(_loginEmailOnChangeEvent);
    on<LoginPasswordOnChangeEvent>(_loginPasswordOnChangeEvent);
    on<LoginHiddenOnClickEvent>(_loginHiddenOnClickEvent);
    on<CaptchaOnClickEvent>(_captchaOnClickEvent);
  }

  FutureOr<void> _loginEmailOnChangeEvent(LoginEmailOnChangeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(email:event.email));
  }

  FutureOr<void> _loginPasswordOnChangeEvent(LoginPasswordOnChangeEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(password:event.password));
  }

  FutureOr<void> _loginHiddenOnClickEvent(LoginHiddenOnClickEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(isHidden:event.isHidden));
  }


  FutureOr<void> _captchaOnClickEvent(CaptchaOnClickEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(captchaResult:event.captchaResult));
  }
}
