import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<ChangePasswordButtonErrorEvent>(changePasswordButtonErrorEvent);
    on<ChangePasswordButtonLoadingEvent>(changePasswordButtonLoadingEvent);
    on<ChangePasswordButtonSuccessEvent>(changePasswordButtonSuccessEvent);
  }

  FutureOr<void> changePasswordButtonSuccessEvent(
      ChangePasswordButtonSuccessEvent event,
      Emitter<ChangePasswordState> emit) {
    emit(ChangePasswordButtonSuccessState());
  }

  FutureOr<void> changePasswordButtonErrorEvent(
      ChangePasswordButtonErrorEvent event, Emitter<ChangePasswordState> emit) {
    emit(ChangePasswordButtonErrorState(event.message));
  }

  FutureOr<void> changePasswordButtonLoadingEvent(
      ChangePasswordButtonLoadingEvent event,
      Emitter<ChangePasswordState> emit) {
    emit(ChangePasswordButtonLoadingState());
  }
}
