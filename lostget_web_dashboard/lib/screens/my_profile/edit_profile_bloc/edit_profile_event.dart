part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {}
class EditProfileButtonPressedEvent extends EditProfileEvent{

}
class CancelEditProfileButtonPressedEvent extends EditProfileEvent{

}