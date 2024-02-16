import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_get/common/constants/profile_settings_constants.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/Settings/UserPreference/user_preference_screen.dart';
import 'package:lost_get/presentation_layer/widgets/profile_settings_widget.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic_layer/ProfileSettings/Settings/bloc/settings_bloc.dart';
import '../../../../business_logic_layer/Provider/change_theme_mode.dart';
import 'ManageAccount/manage_account.dart';

class EditProfileSettings extends StatefulWidget {
  const EditProfileSettings({super.key});

  static const routeName = '/settings';

  @override
  State<EditProfileSettings> createState() => _EditProfileSettingsState();
}

class _EditProfileSettingsState extends State<EditProfileSettings> {
  final SettingsBloc settingsBloc = SettingsBloc();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> settingsList =
        ProfileSettingsConstants(settingsBloc: settingsBloc).getSettingsList();
    return Consumer(
      builder: (context, ChangeThemeMode value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          iconTheme: IconThemeData(
            color: value.isDarkMode()
                ? Colors.white
                : Colors.black, //change your color here
          ),
          centerTitle: true,
        ),
        body: BlocListener<SettingsBloc, SettingsState>(
          bloc: settingsBloc,
          listenWhen: (previous, current) => current is SettingsActionState,
          listener: (context, state) {
            if (state is UserPreferenceButtonClickedState) {
              Navigator.pushNamed(context, UserPreferenceScreen.routeName);
              settingsBloc.add(ReleasedButtonEvent());
            }

            if (state is ManageAccountButtonClickedState) {
              Navigator.pushNamed(context, ManageAccount.routeName);
              settingsBloc.add(ReleasedButtonEvent());
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: ListView.builder(
              itemBuilder: (context, index) {
                var data = settingsList[index];
                return createListTile(context, data['title'], data['subtitle'],
                    null, data['handleFunction'], value.isDarkMode());
              },
              itemCount: settingsList.length,
            ),
          ),
        ),
      ),
    );
  }
}
