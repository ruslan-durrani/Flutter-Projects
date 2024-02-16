import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/Settings/ManageAccount/ChangePassword/change_password.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/Settings/ManageAccount/ChangePhoneNumber/change_phone_number.dart';

import '../../../../../business_logic_layer/ProfileSettings/Settings/ManageAccount/bloc/manage_account_bloc.dart';
import '../../../../widgets/profile_settings_widget.dart';

class ManageAccount extends StatelessWidget {
  const ManageAccount({super.key});

  static const routeName = '/manage_account';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeThemeMode>();
    final ManageAccountBloc manageAccountBloc = ManageAccountBloc();
    return BlocListener<ManageAccountBloc, ManageAccountState>(
      bloc: manageAccountBloc,
      listenWhen: (previous, current) => current is ManageAccountActionState,
      listener: (context, state) {
        if (state is ChangePhoneNumberClickedState) {
          Navigator.pushNamed(context, ChangePhoneNumber.routeName);
          manageAccountBloc.add(ReleasedButtonEvent());
        }
        if (state is ChangePasswordClickedState) {
          Navigator.pushNamed(context, ChangePasswordScreen.routeName);
          manageAccountBloc.add(ReleasedButtonEvent());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Manage Account",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          iconTheme: IconThemeData(
            color: provider.isDarkMode()
                ? Colors.white
                : Colors.black, //change your color here
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createListTile(
                    context,
                    "Change Password",
                    null,
                    null,
                    () => manageAccountBloc.add(ChangePasswordClickedEvent()),
                    provider.isDarkMode()),
                divider(),
                createListTile(
                    context,
                    "Change Phone Number",
                    null,
                    null,
                    () =>
                        manageAccountBloc.add(ChangePhoneNumberClickedEvent()),
                    provider.isDarkMode()),
                divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget createListForManageAccount(
    String title, ChangeThemeMode provider, Function handleOnTap) {
  return InkWell(
    onTap: () {
      handleOnTap();
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        title,
        style: GoogleFonts.roboto(
          color: provider.isDarkMode() ? Colors.white : Colors.black,
          fontSize: 14.sp,
          fontWeight: provider.isDyslexia ? FontWeight.bold : FontWeight.w700,
        ),
      ),
    ),
  );
}

Widget divider() => Divider(
      color: Colors.grey.withOpacity(0.2),
      height: 1,
      thickness: 1,
    );
