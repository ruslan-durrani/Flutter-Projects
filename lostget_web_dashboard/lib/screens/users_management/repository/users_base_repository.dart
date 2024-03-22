


import '../models/user_profile.dart';

abstract class BaseUsersRepository{
  Stream<List<UserProfile>> getAllUserData();
}