part of 'manage_account_bloc.dart';

sealed class ManageAccountEvent extends Equatable {
  const ManageAccountEvent();

  @override
  List<Object> get props => [];
}

final class ChangePhoneNumberClickedEvent extends ManageAccountEvent {}

final class ChangePasswordClickedEvent extends ManageAccountEvent {}

final class ReleasedButtonEvent extends ManageAccountEvent {}
