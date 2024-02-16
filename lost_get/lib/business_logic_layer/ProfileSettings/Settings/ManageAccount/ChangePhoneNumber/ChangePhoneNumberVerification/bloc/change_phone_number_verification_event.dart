part of 'change_phone_number_verification_bloc.dart';

sealed class ChangePhoneNumberVerificationEvent extends Equatable {
  const ChangePhoneNumberVerificationEvent();

  @override
  List<Object> get props => [];
}

final class VerifyButtonClickedEvent
    extends ChangePhoneNumberVerificationEvent {
  final String otp;

  const VerifyButtonClickedEvent({required this.otp});
}
