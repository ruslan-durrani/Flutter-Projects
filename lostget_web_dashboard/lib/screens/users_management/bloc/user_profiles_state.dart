part of 'user_profiles_bloc.dart';

@immutable
abstract class UserProfilesState extends Equatable {
  final List<UserProfile> userProfiles;
   UserProfilesState(this.userProfiles);

  @override
  List<Object> get props => [];
}

class UserProfilesLoading extends UserProfilesState {
  UserProfilesLoading(List<UserProfile> userProfiles) : super(userProfiles);
}

class UserProfilesLoaded extends UserProfilesState {
  final List<UserProfile> userProfiles;
  UserProfilesLoaded(this.userProfiles) : super(userProfiles);
  @override
  List<Object> get props => [userProfiles];
}

class UserProfilesError extends UserProfilesState {
  final String error;
  UserProfilesError(this.error) : super([]);
  @override
  List<Object> get props => [error];
}
