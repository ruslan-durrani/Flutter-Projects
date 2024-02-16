part of 'change_password_bloc.dart';

sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

final class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordActionState extends ChangePasswordState {}

class ChangePasswordButtonErrorState extends ChangePasswordActionState {
  final String message;

  ChangePasswordButtonErrorState(this.message);
}

class ChangePasswordButtonLoadingState extends ChangePasswordActionState {}

class ChangePasswordButtonSuccessState extends ChangePasswordActionState {}
