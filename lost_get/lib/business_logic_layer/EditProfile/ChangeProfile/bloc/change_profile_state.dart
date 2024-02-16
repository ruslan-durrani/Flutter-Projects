part of 'change_profile_bloc.dart';

sealed class ChangeProfileState extends Equatable {
  const ChangeProfileState();

  @override
  List<Object> get props => [];
}

final class ChangeProfileInitialState extends ChangeProfileState {}

final class ChangeProfileLoadingState extends ChangeProfileState {}

final class ChangeProfileLoadedState extends ChangeProfileState {
  final XFile? pickedImage;

  const ChangeProfileLoadedState(this.pickedImage);
}

class ChangeProfileErrorState extends ChangeProfileState {
  final String errorMsg;

  const ChangeProfileErrorState(this.errorMsg);
}
