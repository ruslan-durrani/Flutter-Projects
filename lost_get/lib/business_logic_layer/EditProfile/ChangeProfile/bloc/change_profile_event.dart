part of 'change_profile_bloc.dart';

sealed class ChangeProfileEvent extends Equatable {
  const ChangeProfileEvent();

  @override
  List<Object> get props => [];
}

class ChangeProfileInitialEvent extends ChangeProfileEvent {}
class ChangeProfile extends ChangeProfileEvent {}
