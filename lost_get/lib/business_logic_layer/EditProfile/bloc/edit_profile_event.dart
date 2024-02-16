part of 'edit_profile_bloc.dart';

class EditProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProfileLoadEvent extends EditProfileEvent {}

class FullNameControllerEvent extends EditProfileEvent {
  final String fullName;

  FullNameControllerEvent(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

final class BackButtonPressedEvent extends EditProfileEvent {}

final class SaveButtonClickedEvent extends EditProfileEvent {
  final Map<String, dynamic> newProfileData;
  final UserProfile userProfile;
  final ChangeProfileBloc changeProfileBloc;
  final BuildContext context;

  SaveButtonClickedEvent(this.context, this.newProfileData, this.userProfile,
      this.changeProfileBloc);
}
