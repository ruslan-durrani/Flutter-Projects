part of 'change_phone_number_verification_bloc.dart';

sealed class ChangePhoneNumberVerificationState extends Equatable {
  const ChangePhoneNumberVerificationState();

  @override
  List<Object> get props => [];
}

final class ChangePhoneNumberVerificationInitial
    extends ChangePhoneNumberVerificationState {}

final class ChangePhoneNumberVerificationActioState
    extends ChangePhoneNumberVerificationState {}

final class VerifyButtonClickedSuccessState
    extends ChangePhoneNumberVerificationActioState {}

final class VerifyButtonClickedLoadingState
    extends ChangePhoneNumberVerificationActioState {}

final class VerifyButtonClickedErrorState
    extends ChangePhoneNumberVerificationActioState {
  final String errorMsg;

  VerifyButtonClickedErrorState({required this.errorMsg});
}
