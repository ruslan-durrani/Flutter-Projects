part of 'my_profile_bloc.dart';

@immutable
abstract class MyProfileState extends Equatable{
  @override
  List<UserProfile> get props => [];
}

class MyProfileInitial extends MyProfileState {}
class MyProfilesLoading extends MyProfileState {}
class MyProfileLoaded extends MyProfileState{
  final UserProfile myProfile;
  MyProfileLoaded(this.myProfile);
  @override
  List<UserProfile> get props => [myProfile];
}

class MyProfileError extends MyProfileState {
  final String error;
  MyProfileError(this.error);
  @override
  List<UserProfile> get props => [];
}
