import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/controller/Settings/Manage%20Account/ChangePhoneNumber/change_phone_number_controller.dart';

part 'change_phone_number_verification_event.dart';
part 'change_phone_number_verification_state.dart';

class ChangePhoneNumberVerificationBloc extends Bloc<
    ChangePhoneNumberVerificationEvent, ChangePhoneNumberVerificationState> {
  ChangePhoneNumberVerificationBloc()
      : super(ChangePhoneNumberVerificationInitial()) {
    on<VerifyButtonClickedEvent>(verifyButtonClickedEvent);
  }

  Future<FutureOr<void>> verifyButtonClickedEvent(
      VerifyButtonClickedEvent event,
      Emitter<ChangePhoneNumberVerificationState> emit) async {
    emit(VerifyButtonClickedLoadingState());

    final bool result =
        await ChangePhoneNumberController().verifyOtp(event.otp);
    if (result) {
      emit(VerifyButtonClickedSuccessState());
    } else {
      emit(VerifyButtonClickedErrorState(
          errorMsg: "Phone Number is not verified"));
    }
  }
}
