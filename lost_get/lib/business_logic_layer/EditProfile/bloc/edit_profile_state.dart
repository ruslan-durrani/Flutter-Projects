part of 'edit_profile_bloc.dart';

@immutable
sealed class EditProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProfileInitialState extends EditProfileState {}

class EditProfileLoadingState extends EditProfileState {}

class EditProfileActionState extends EditProfileState {}

class EditProfileLoadedState extends EditProfileState {
  final UserProfile userProfile;

  EditProfileLoadedState(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class EditProfileErrorState extends EditProfileState {
  final String errorMsg;

  EditProfileErrorState(this.errorMsg);
  @override
  List<Object?> get props => [errorMsg];
}

class FullNameControllerState extends EditProfileState {
  final String fullName;

  FullNameControllerState(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

final class SaveButtonClickedSuccessState extends EditProfileActionState {
  SaveButtonClickedSuccessState();
}

final class SaveButtonClickedLoadingState extends EditProfileActionState {}

final class SaveButtonClickedErrorState extends EditProfileActionState {
  final String description;

  SaveButtonClickedErrorState(this.description);
}
