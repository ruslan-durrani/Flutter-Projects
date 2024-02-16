part of 'change_phone_number_verified_cubit.dart';

sealed class ChangePhoneNumberVerifiedState extends Equatable {
  const ChangePhoneNumberVerifiedState();

  @override
  List<Object> get props => [];
}

final class ChangePhoneNumberVerifiedInitial
    extends ChangePhoneNumberVerifiedState {}

final class BackToMainMenuButtonClickedState
    extends ChangePhoneNumberVerifiedState {}
