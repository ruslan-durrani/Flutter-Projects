


import '../models/userProfile.dart';

abstract class BaseUsersRepository{
  Stream<List<UserProfile>> getAllUserData();
}