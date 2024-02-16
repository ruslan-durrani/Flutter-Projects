part of 'change_phone_number_bloc.dart';

sealed class ChangePhoneNumberState extends Equatable {
  const ChangePhoneNumberState();

  @override
  List<Object> get props => [];
}

final class ChangePhoneNumberInitial extends ChangePhoneNumberState {}

final class ChangePhoneNumberActionState extends ChangePhoneNumberState {}

final class AcquirePhoneNumberSuccessState extends ChangePhoneNumberState {
  final String phoneNumber;
  final String isoCountryCode;

  const AcquirePhoneNumberSuccessState(this.phoneNumber, this.isoCountryCode);

  @override
  List<Object> get props => [phoneNumber, isoCountryCode];
}

final class AcquirePhoneNumberLoadingState extends ChangePhoneNumberState {}

final class AcquirePhoneNumberErrorState extends ChangePhoneNumberState {
  final String errorMsg;

  const AcquirePhoneNumberErrorState(this.errorMsg);
}

final class ContinueButtonClickedLoadingState
    extends ChangePhoneNumberActionState {}

final class ContinueButtonClickedSuccessState
    extends ChangePhoneNumberActionState {}

final class ContinueButtonClickedErrorState
    extends ChangePhoneNumberActionState {
  final String errorMsg;

  ContinueButtonClickedErrorState({required this.errorMsg});
}

final class ContinueButtonClickedState extends ChangePhoneNumberActionState {}

final class ButtonReleasedState extends ChangePhoneNumberActionState {}
