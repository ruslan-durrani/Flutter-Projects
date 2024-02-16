import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'manage_account_event.dart';
part 'manage_account_state.dart';

class ManageAccountBloc extends Bloc<ManageAccountEvent, ManageAccountState> {
  ManageAccountBloc() : super(ManageAccountInitial()) {
    on<ChangePhoneNumberClickedEvent>(changePhoneNumberClickedEvent);
    on<ReleasedButtonEvent>(releasedButtonEvent);
    on<ChangePasswordClickedEvent>(changePasswordClickedEvent);
  }

  FutureOr<void> changePhoneNumberClickedEvent(
      ChangePhoneNumberClickedEvent event, Emitter<ManageAccountState> emit) {
    emit(ChangePhoneNumberClickedState());
  }

  FutureOr<void> releasedButtonEvent(
      ReleasedButtonEvent event, Emitter<ManageAccountState> emit) {
    emit(ReleasedButtonState());
  }

  FutureOr<void> changePasswordClickedEvent(
      ChangePasswordClickedEvent event, Emitter<ManageAccountState> emit) {
    emit(ChangePasswordClickedState());
  }
}
