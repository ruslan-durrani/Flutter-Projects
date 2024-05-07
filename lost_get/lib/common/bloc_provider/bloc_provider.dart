import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_get/business_logic_layer/AddReport/bloc/add_report_detail_bloc.dart';
import 'package:lost_get/business_logic_layer/Authentication/Signup/bloc/sign_up_bloc.dart';
import 'package:lost_get/business_logic_layer/Authentication/Verification/bloc/email_verification_bloc.dart';
import 'package:lost_get/business_logic_layer/Dashboard/bloc/dashboard_bloc.dart';
import 'package:lost_get/business_logic_layer/EditProfile/ChangeProfile/bloc/change_profile_bloc.dart';
import 'package:lost_get/business_logic_layer/EditProfile/bloc/edit_profile_bloc.dart';
import 'package:lost_get/business_logic_layer/MyReports/bloc/my_reports_bloc.dart';
import 'package:lost_get/business_logic_layer/Onboard/bloc/onboard_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePassword/bloc/change_password_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePhoneNumber/ChangePhoneNumberVerification/bloc/change_phone_number_verification_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePhoneNumber/ChangePhoneNumberVerified/cubit/change_phone_number_verified_cubit.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePhoneNumber/bloc/change_phone_number_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/bloc/manage_account_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/bloc/settings_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/UserPreference/bloc/user_preference_bloc.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/bloc/profile_settings_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/business_logic_layer/Provider/modify_report_provider.dart';
import 'package:lost_get/business_logic_layer/Provider/report_status_provider.dart';
import 'package:lost_get/business_logic_layer/QRCodeScanner/bloc/qr_code_scanner_bloc.dart';
import 'package:provider/provider.dart';

import '../../business_logic_layer/Authentication/Signin/bloc/sign_in_bloc.dart';
import '../../business_logic_layer/Provider/password_validator_provider.dart';
import '../../presentation_layer/screens/Messenger/business_logic/ChatHomeProvider.dart';

class AppBlocProvider {
  static get allBlocProvider => [
        BlocProvider(create: (_) => SignInBloc()),
        BlocProvider(create: (_) => SignUpBloc()),
        BlocProvider(create: (_) => EmailVerificationBloc()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => OnboardBloc()),
        BlocProvider(create: (_) => ProfileSettingsBloc()),
        BlocProvider(create: (_) => EditProfileBloc()),
        BlocProvider(create: (_) => ChangeProfileBloc()),
        BlocProvider(create: (_) => UserPreferenceBloc()),
        BlocProvider(create: (_) => SettingsBloc()),
        BlocProvider(create: (_) => ManageAccountBloc()),
        BlocProvider(create: (_) => ChangePhoneNumberBloc()),
        BlocProvider(create: (context) => ChangePhoneNumberVerificationBloc()),
        BlocProvider(create: (_) => ChangePhoneNumberVerifiedCubit()),
        BlocProvider(create: (_) => ChangePasswordBloc()),
        BlocProvider(create: (_) => AddReportDetailBloc()),
        BlocProvider(create: (_) => MyReportsBloc()),
        BlocProvider(create: (_) => QrCodeScannerBloc()),
        ChangeNotifierProvider(create: (_) => PasswordStrengthProvider()),
        ChangeNotifierProvider(create: (_) => ChangeThemeMode()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => ModifyReportProvider()),
        ChangeNotifierProvider(create: (_) => ReportStatusProvider())
      ];
}
