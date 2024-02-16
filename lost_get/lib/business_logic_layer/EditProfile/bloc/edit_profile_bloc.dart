import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:lost_get/business_logic_layer/EditProfile/ChangeProfile/bloc/change_profile_bloc.dart';

import 'package:lost_get/controller/Profile%20Settings/edit_profile_controller.dart';
import 'package:meta/meta.dart';

import '../../../models/user_profile.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitialState()) {
    on<EditProfileLoadEvent>(editProfileLoadedEvent);
    on<FullNameControllerEvent>(fullNameControllerEvent);
    on<SaveButtonClickedEvent>(saveButtonClickedEvent);
  }

  FutureOr<void> editProfileLoadedEvent(
      EditProfileEvent event, Emitter<EditProfileState> emit) async {
    emit(EditProfileLoadingState());

    try {
      UserProfile userProfile = await EditProfileController().getUserData();
      if (userProfile != null) {
        emit(EditProfileLoadedState(userProfile));
      } else {
        emit(EditProfileErrorState("Edit Profile page can't load."));
      }
    } catch (e) {
      emit(EditProfileErrorState("Edit Profile page can't load."));
    }
  }

  FutureOr<void> fullNameControllerEvent(
      FullNameControllerEvent event, Emitter<EditProfileState> emit) {
    emit(FullNameControllerState(event.fullName));
  }

  Future<FutureOr<void>> saveButtonClickedEvent(
      SaveButtonClickedEvent event, Emitter<EditProfileState> emit) async {
    emit(SaveButtonClickedLoadingState());
    var result = await EditProfileController()
        .updateUserData(event.newProfileData, event.userProfile);
    if (result == true) {
      emit(SaveButtonClickedSuccessState());
      event.changeProfileBloc.add(ChangeProfileInitialEvent());
    } else {
      emit(SaveButtonClickedErrorState(
          "Please update the fields to make changes."));
    }
  }
}
