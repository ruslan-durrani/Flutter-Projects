part of 'change_password_bloc.dart';

sealed class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordButtonErrorEvent extends ChangePasswordEvent {
  final String message;

  const ChangePasswordButtonErrorEvent(this.message);
}

class ChangePasswordButtonLoadingEvent extends ChangePasswordEvent {}

class ChangePasswordButtonSuccessEvent extends ChangePasswordEvent {}
