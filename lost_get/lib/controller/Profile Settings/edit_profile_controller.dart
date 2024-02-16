import 'package:firebase_auth/firebase_auth.dart';

import '../../business_logic_layer/EditProfile/ChangeProfile/bloc/change_profile_bloc.dart';
import '../../business_logic_layer/EditProfile/bloc/edit_profile_bloc.dart';
import '../../data_store_layer/repository/users_repository.dart';
import '../../models/user_profile.dart';

class EditProfileController {
  static String oldImgUrl = '';
  final EditProfileBloc? editProfileBloc;
  final ChangeProfileBloc? changeProfileBloc;
  final UserRepository _userRepo = UserRepository();

  EditProfileController({this.editProfileBloc, this.changeProfileBloc});

  getUserData() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      return _userRepo.getUserDetails(uid);
    }
  }

  updateUserData(
      Map<String, dynamic> newProfileData, UserProfile oldProfileData) async {
    final String fullName = newProfileData['fullName'];
    final String biography = newProfileData['biography'];
    final String gender = newProfileData['gender'];
    final String dateOfBirth = newProfileData['dateOfBirth'];
    // final String email = newProfileData['email'];
    // var phoneNumber = newProfileData['phoneNumber'];
    var imgUrl = newProfileData['imgUrl'];

    Map<String, dynamic> newMap = {};

    if (oldProfileData.fullName != fullName) {
      print("1");
      newMap['fullName'] = fullName;
    }

    if (oldProfileData.biography != biography) {
      print("2");
      newMap['biography'] = biography;
    }

    if (oldProfileData.dateOfBirth != dateOfBirth &&
        oldProfileData.dateOfBirth != "DD/MM/YYYY") {
      print("3");
      newMap['dateOfBirth'] = dateOfBirth;
    }

    if (oldProfileData.gender != gender) {
      print("6");
      newMap['gender'] = gender;
    }

    if (imgUrl != null && oldProfileData.imgUrl != imgUrl) {
      print("7");
      var generateImageUrl = await _userRepo.uploadProfileImage(imgUrl);
      print("Generated $generateImageUrl");
      newMap['imgUrl'] = generateImageUrl;
      oldImgUrl = generateImageUrl;
    }

    if (newMap.isEmpty) {
      print("nothings changed");
      return false;
    } else {
      print("changed");
      _userRepo.updateUserData(FirebaseAuth.instance.currentUser!.uid, newMap);
      return true;
    }
  }
}
