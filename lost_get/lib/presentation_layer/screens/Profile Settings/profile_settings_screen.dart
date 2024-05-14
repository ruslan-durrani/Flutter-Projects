import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/presentation_layer/screens/Authentication/Signin/sign_in_screen.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/EditProfile/edit_profile.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/Settings/settings_screen.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/ViewPoliceStatus/police_status_screen.dart';
import 'package:lost_get/presentation_layer/widgets/alert_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/profile_settings_widget.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:provider/provider.dart';

import '../../../business_logic_layer/ProfileSettings/bloc/profile_settings_bloc.dart';
import '../../../common/constants/profile_settings_constants.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  ProfileSettingsBloc profileSettingsBloc = ProfileSettingsBloc();
  String? _uploadedImageUrl;
  String? _username;

  @override
  void initState() {
    profileSettingsBloc.add(UserProfileLoadingEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSettingsBloc, ProfileSettingsState>(
      bloc: profileSettingsBloc,
      listener: (context, state) {
        if (state is SettingsButtonClickedState) {
          Navigator.pushNamed(context, EditProfileSettings.routeName);
        }

        if (state is EditProfileButtonClickedState) {
          Navigator.pushNamed(context, EditProfile.routeName).then(
              (value) => profileSettingsBloc.add(UserProfileLoadingEvent()));
        }

        if (state is SignOutAlertDialogState) {
          alertDialog(
            context,
            "Are you sure? You want to log out?",
            "Log Out",
            "No",
            "Log Out",
            () => Navigator.pop(context),
            () => profileSettingsBloc.add(SignOutEvent()),
          );
        }

        if (state is ViewPoliceStatusButtonClickedState) {
          Navigator.pushNamed(context, ViewPoliceStatusScreen.routeName);
        }

        if (state is SignOutLoadingSuccessState) {
          createToast(description: "Logged out successfully!");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 18, right: 18, top: 14),
            child: Column(
              children: [
                BlocBuilder<ProfileSettingsBloc, ProfileSettingsState>(
                  bloc: profileSettingsBloc,
                  builder: (context, state) {
                    if (state is UserProfileLoadingState) {}

                    if (state is UserProfileErrorState) {
                      createToast(description: state.msg);
                    }

                    if (state is UserProfileLoadedState) {
                      _uploadedImageUrl = state.userProfile.imgUrl;
                      _username = state.userProfile.fullName;
                      return Row(children: [
                        Container(
                            width: 110.w,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              image: _uploadedImageUrl != null &&
                                      _uploadedImageUrl != ""
                                  ? DecorationImage(
                                      image: NetworkImage(_uploadedImageUrl!),
                                      fit: BoxFit.cover)
                                  : const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        "https://firebasestorage.googleapis.com/v0/b/lostget-faafe.appspot.com/o/defaultProfileImage.png?alt=media&token=15627898-29b2-47a1-b9cc-95c93a158cd1",
                                      )),
                            )),
                        SizedBox(
                          width: 18.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _username != null && _username != ""
                                  ? _username.toString()
                                  : "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Consumer(
                              builder:
                                  (context, ChangeThemeMode value, child) =>
                                      InkWell(
                                onTap: () => profileSettingsBloc
                                    .add(EditProfileButtonClickedEvent()),
                                child: Text("View and edit profile",
                                    style: GoogleFonts.roboto(
                                      color: value.isDarkMode()
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: value.isDyslexia
                                          ? FontWeight.w900
                                          : FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationColor: value.isDarkMode()
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                              ),
                            )
                          ],
                        ),
                      ]);
                    }
                    return Row(children: [
                      Container(
                        width: 110.w,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                          image: _uploadedImageUrl != null &&
                                  _uploadedImageUrl != ""
                              ? DecorationImage(
                                  image: NetworkImage(_uploadedImageUrl!),
                                  fit: BoxFit.cover)
                              : const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/lostget-faafe.appspot.com/o/defaultProfileImage.png?alt=media&token=15627898-29b2-47a1-b9cc-95c93a158cd1",
                                  )),
                        ),
                      ),
                      SizedBox(
                        width: 18.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username != null && _username != ""
                                ? _username.toString()
                                : "",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Consumer(
                            builder: (context, ChangeThemeMode value, child) =>
                                InkWell(
                              onTap: () => profileSettingsBloc
                                  .add(EditProfileButtonClickedEvent()),
                              child: Text("View and edit profile",
                                  style: GoogleFonts.roboto(
                                    color: value.isDarkMode()
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: value.isDyslexia
                                        ? FontWeight.w900
                                        : FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: value.isDarkMode()
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ]);
                  },
                ),
                SizedBox(
                  height: 15.h,
                ),
                Consumer(
                  builder: (context, ChangeThemeMode value, child) {
                    List<Map<String, dynamic>> profileList =
                        ProfileSettingsConstants(
                                profileSettingsBloc: profileSettingsBloc,
                                isDark: value.isDarkMode())
                            .getProfileList();
                    return Column(
                      children: profileList
                          .map(
                            (e) => createListTile(
                                context,
                                e['title'] as String,
                                e['subtitle'] as String,
                                e['imgUrl'] as String,
                                e['handleFunction'] as Function,
                                value.isDarkMode()),
                          )
                          .toList(),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
