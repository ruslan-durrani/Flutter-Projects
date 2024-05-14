import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/bloc/settings_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/bloc/profile_settings_bloc.dart';
import 'package:lost_get/common/constants/constant.dart';

class ProfileSettingsConstants {
  final ProfileSettingsBloc? profileSettingsBloc;
  final SettingsBloc? settingsBloc;
  final bool? isDark;

  ProfileSettingsConstants(
      {this.profileSettingsBloc, this.settingsBloc, this.isDark});
  List<Map<String, dynamic>> getProfileList() {
    return [
      {
        'imgUrl': isDark != null && isDark == true
            ? 'assets/icons/dark_view_my_reports.svg'
            : 'assets/icons/view_my_report.svg',
        'title': 'View Police Station Status',
        'subtitle': 'View your reported to police station items status',
        'handleFunction': () {
          profileSettingsBloc!.add(ViewPoliceStatusButtonClickedEvent());
        },
      },
      // {
      //   'imgUrl': isDark != null && isDark == true
      //       ? 'assets/icons/dark_support.svg'
      //       : 'assets/icons/support.svg',
      //   'title': 'Support and Help',
      //   'subtitle': 'Help centre and Legal Provisions',
      //   'handleFunction': () {},
      // },
      {
        'imgUrl': isDark != null && isDark == true
            ? 'assets/icons/dark_setting.svg'
            : 'assets/icons/setting.svg',
        'title': 'Settings',
        'subtitle': 'Privacy and manage your account',
        'handleFunction': () {
          profileSettingsBloc!.add(SettingsButtonClickedEvent());
        },
      },
      // {
      //   'imgUrl': isDark != null && isDark == true
      //       ? 'assets/icons/dark_share_feedback.svg'
      //       : 'assets/icons/share_feedback.svg',
      //   'title': 'Share Feedback',
      //   'subtitle': 'Share your valuable feedback with us',
      //   'handleFunction': () {},
      // },
      {
        'imgUrl': isDark != null && isDark == true
            ? 'assets/icons/dark_logout.svg'
            : 'assets/icons/logout.svg',
        'title': 'Log Out',
        'subtitle': 'Log out your account',
        'handleFunction': () {
          profileSettingsBloc!.add(SignOutAlertDialogEvent());
        },
      }
    ];
  }

  List<Map<String, dynamic>> getSettingsList() {
    return [
      {
        'title': "Manage Account",
        'subtitle': "Manage your personal details.",
        'handleFunction': () =>
            settingsBloc!.add(ManageAccountButtonClickedEvent())
      },
      {
        'title': "User Preference",
        'subtitle': "Customize application appearance",
        'handleFunction': () {
          settingsBloc!.add(UserPreferenceButtonClickedEvent());
        }
      },
      {
        'title': "Notifications",
        'subtitle': "Manage push & recommendation notifications",
        'handleFunction': () {}
      },
      {
        'title': "Privacy Policy",
        'subtitle': "Look into our app privacy policy",
        'handleFunction': () {}
      },
    ];
  }
}
