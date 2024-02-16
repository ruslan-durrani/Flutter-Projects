part of 'manage_account_bloc.dart';

sealed class ManageAccountState extends Equatable {
  const ManageAccountState();

  @override
  List<Object> get props => [];
}

final class ManageAccountInitial extends ManageAccountState {}

final class ManageAccountActionState extends ManageAccountState {}

final class ChangePhoneNumberClickedState extends ManageAccountActionState {}

final class ChangePasswordClickedState extends ManageAccountActionState {}

final class ReleasedButtonState extends ManageAccountActionState {}
