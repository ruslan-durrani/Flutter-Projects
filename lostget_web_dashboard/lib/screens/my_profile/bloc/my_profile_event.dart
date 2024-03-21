part of 'my_profile_bloc.dart';

@immutable
abstract class MyProfileEvent extends Equatable{
  const MyProfileEvent();
  @override
  List<Object> get props => [];
}
class GetMyProfileDataEvent extends MyProfileEvent {}
class ProfileEditEvent extends MyProfileEvent{
  final bool editStatus;

  ProfileEditEvent({required this.editStatus});
}