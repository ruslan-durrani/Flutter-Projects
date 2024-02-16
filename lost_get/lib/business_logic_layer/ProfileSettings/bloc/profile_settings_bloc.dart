import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../controller/Authentication/sign_in_controller.dart';
import '../../../controller/Profile Settings/edit_profile_controller.dart';
import '../../../models/user_profile.dart';

part 'profile_settings_event.dart';
part 'profile_settings_state.dart';

class ProfileSettingsBloc
    extends Bloc<ProfileSettingsEvent, ProfileSettingsState> {
  ProfileSettingsBloc() : super(ProfileSettingsInitial()) {
    on<EditProfileButtonClickedEvent>(editProfileButtonClickedEvent);
    on<SignOutEvent>(signOutEvent);
    on<SignOutAlertDialogEvent>(signOutAlertDialogEvent);
    on<SettingsButtonClickedEvent>(settingsButtonClickedEvent);
    on<UserProfileLoadingEvent>(userProfileLoadingEvent);
  }

  FutureOr<void> editProfileButtonClickedEvent(
      EditProfileButtonClickedEvent event, Emitter<ProfileSettingsState> emit) {
    emit(EditProfileButtonClickedState());
  }

  Future<FutureOr<void>> signOutEvent(
      SignOutEvent event, Emitter<ProfileSettingsState> emit) async {
    emit(SignOutLoadingState());
    final SignInController signInController = SignInController();
    bool result = await signInController.signOut();

    if (result == true) {
      emit(SignOutLoadingSuccessState());
    } else {
      emit(SignOutLoadingErrorState());
    }
  }

  FutureOr<void> signOutAlertDialogEvent(
      SignOutAlertDialogEvent event, Emitter<ProfileSettingsState> emit) {
    emit(SignOutAlertDialogState());
  }

  FutureOr<void> settingsButtonClickedEvent(
      SettingsButtonClickedEvent event, Emitter<ProfileSettingsState> emit) {
    emit(SettingsButtonClickedState());
  }

  Future<FutureOr<void>> userProfileLoadingEvent(
      UserProfileLoadingEvent event, Emitter<ProfileSettingsState> emit) async {
    emit(UserProfileLoadingState());

    try {
      UserProfile userProfile = await EditProfileController().getUserData();
      if (userProfile != null) {
        print(userProfile.fullName);
        emit(UserProfileLoadedState(userProfile));
      } else {
        emit(UserProfileErrorState("Edit Profile page can't load."));
      }
    } catch (e) {
      emit(UserProfileErrorState("Edit Profile page can't load."));
    }
  }
}
