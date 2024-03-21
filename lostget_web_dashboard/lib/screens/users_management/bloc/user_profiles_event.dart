part of 'user_profiles_bloc.dart';

@immutable

abstract class UserProfilesEvent extends Equatable {
  const UserProfilesEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfilesEvent extends UserProfilesEvent {}

class SearchFilterUsersProfilesEvent extends UserProfilesEvent{
  final String controllerText;
  SearchFilterUsersProfilesEvent(this.controllerText);
}