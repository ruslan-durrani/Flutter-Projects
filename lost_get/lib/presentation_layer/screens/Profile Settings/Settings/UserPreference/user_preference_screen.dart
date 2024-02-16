import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:provider/provider.dart';

import '../../../../../business_logic_layer/ProfileSettings/UserPreference/bloc/user_preference_bloc.dart';

class UserPreferenceScreen extends StatefulWidget {
  static const routeName = '/user_preference';
  const UserPreferenceScreen({super.key});

  @override
  State<UserPreferenceScreen> createState() => _UserPreferenceScreenState();
}

OverlayEntry? overlayEntry;

class _UserPreferenceScreenState extends State<UserPreferenceScreen> {
  final UserPreferenceBloc _userPreferenceBloc = UserPreferenceBloc();

  void showDarkModeDialog(
      BuildContext context, ChangeThemeMode changeThemeMode) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, value, child) => AlertDialog(
          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
          backgroundColor:
              changeThemeMode.isDarkMode() ? Colors.black : Colors.white,
          title: const Text("Select Theme"),
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<int>(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hoverColor: null,
                title: Text(
                  "No",
                  style: GoogleFonts.roboto(
                    color: changeThemeMode.isDarkMode()
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14.sp,
                    fontWeight: changeThemeMode.isDyslexia
                        ? FontWeight.bold
                        : FontWeight.w700,
                  ),
                ),
                groupValue: changeThemeMode.tempDarkMode,
                onChanged: (value) {
                  changeThemeMode.setDarkMode(value!);
                },
                value: 0,
              ),
              RadioListTile<int>(
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                hoverColor: null,
                title: Text(
                  "Yes",
                  style: GoogleFonts.roboto(
                    color: changeThemeMode.isDarkMode()
                        ? Colors.white
                        : Colors.black,
                    fontSize: 14.sp,
                    fontWeight: changeThemeMode.isDyslexia
                        ? FontWeight.bold
                        : FontWeight.w700,
                  ),
                ),
                groupValue: changeThemeMode.tempDarkMode,
                onChanged: (value) {
                  // changeThemeMode.toggleTheme(value!);
                  changeThemeMode.setDarkMode(value!);
                },
                value: 1,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (changeThemeMode.tempDarkMode == changeThemeMode.darkMode) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Future.delayed(
                    const Duration(milliseconds: 200),
                    () => changeThemeMode
                        .toggleTheme(changeThemeMode.tempDarkMode),
                  );
                }
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ChangeThemeMode changeThemeMode, child) => Scaffold(
        appBar: AppBar(
            title: Text("User Preference",
                style: Theme.of(context).textTheme.bodyMedium),
            iconTheme: IconThemeData(
                color:
                    changeThemeMode.isDarkMode() ? Colors.white : Colors.black),
            centerTitle: true),
        body: BlocListener<UserPreferenceBloc, UserPreferenceState>(
          bloc: _userPreferenceBloc,
          listener: (context, state) {
            if (state is DarkModeButtonClickedState) {
              showDarkModeDialog(context, changeThemeMode);
              _userPreferenceBloc.add(ButtonReleasedEvent());
            }
          },
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      _userPreferenceBloc.add(DarkModeButtonClickedEvent());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Dark Mode",
                        style: GoogleFonts.roboto(
                          color: changeThemeMode.isDarkMode()
                              ? Colors.white
                              : Colors.black,
                          fontSize: 14.sp,
                          fontWeight: changeThemeMode.isDyslexia
                              ? FontWeight.bold
                              : FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    height: 1,
                    thickness: 1,
                  ),
                  SwitchListTile(
                    hoverColor: null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    title: Text(
                      "Dyslexia Friendly",
                      style: GoogleFonts.roboto(
                        color: changeThemeMode.isDarkMode()
                            ? Colors.white
                            : Colors.black,
                        fontSize: 14.sp,
                        fontWeight: changeThemeMode.isDyslexia
                            ? FontWeight.bold
                            : FontWeight.w700,
                      ),
                    ),
                    value: changeThemeMode.isDyslexia,
                    onChanged: (value) {
                      changeThemeMode.toggleDyslexia(value);
                    },
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    height: 1,
                    thickness: 1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
