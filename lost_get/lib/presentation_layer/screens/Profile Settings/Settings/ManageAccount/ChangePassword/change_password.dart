import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePassword/bloc/change_password_bloc.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/business_logic_layer/Provider/password_validator_provider.dart';
import 'package:lost_get/controller/Settings/Manage%20Account/ChangePassword/change_password_controller.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/Settings/ManageAccount/ChangePassword/ChangePasswordVerified/change_password_verified.dart';
import 'package:lost_get/presentation_layer/widgets/authentication_widget.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/controller_validators.dart';
import 'package:lost_get/presentation_layer/widgets/custom_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/password_field.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
  static const routeName = '/change_password';
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final ChangePasswordBloc changePasswordBloc = ChangePasswordBloc();
  final _formKey = GlobalKey<FormState>();

  void _handlePasswordChange(strength) {
    if (_formKey.currentState!.validate() && strength >= 2 / 4) {
      ChangePasswordController().handlePasswordChange(
          _currentPasswordController,
          _newPasswordController,
          changePasswordBloc);
    } else {
      print("Weak");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeThemeMode>();
    final passwordProvider = context.watch<PasswordStrengthProvider>();
    PreferredSizeWidget? appBar = AppBar(
      iconTheme: IconThemeData(
        color: provider.isDarkMode()
            ? Colors.white
            : Colors.black, //change your color here
      ),
      centerTitle: true,
    );
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      bloc: changePasswordBloc,
      listener: (context, state) {
        if (state is ChangePasswordButtonLoadingState) {
          showCustomLoadingDialog(context, "Please Wait...");
        }
        if (state is ChangePasswordButtonErrorState) {
          hideCustomLoadingDialog(context);
          createToast(description: state.message);
        }

        if (state is ChangePasswordButtonSuccessState) {
          hideCustomLoadingDialog(context);
          Navigator.popAndPushNamed(
              context, ChangePasswordVerifiedScreen.routeName);
        }
      },
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height: (MediaQuery.sizeOf(context).height -
                      appBar.preferredSize.height) *
                  0.9,
              margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 13.h,
                    ),
                    headingText(context, "Change Password"),
                    SizedBox(height: 3.h),
                    Text(
                      "Enter your current and new password. Keep your password strong.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    PasswordField(
                        textHint: "Enter Old Password",
                        title: "Current Password",
                        imageUrl: "assets/icons/lock.svg",
                        isHidden: passwordProvider.isHidden,
                        toggleEye: () {
                          passwordProvider.setIsHidden();
                        },
                        handleValidator: (value) =>
                            ControllerValidator.validateLogInPasswordField(
                                value),
                        controller: _currentPasswordController),
                    SizedBox(
                      height: 10.h,
                    ),
                    PasswordField(
                        textHint: "Enter Password",
                        title: "New Password",
                        imageUrl: "assets/icons/lock.svg",
                        isHidden: passwordProvider.newIsHidden,
                        toggleEye: () {
                          passwordProvider.setNewIsHidden();
                        },
                        handleOnChange: (value) =>
                            passwordProvider.checkPassword(value),
                        controller: _newPasswordController),
                    SizedBox(
                      height: 9.h,
                    ),
                    LinearProgressIndicator(
                      value: passwordProvider.strength,
                      backgroundColor: Colors.grey[300],
                      color: passwordProvider.strength <= 1 / 4
                          ? Colors.red
                          : passwordProvider.strength == 2 / 4
                              ? Colors.yellow
                              : passwordProvider.strength == 3 / 4
                                  ? Colors.blue
                                  : Colors.green,
                      minHeight: 10,
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Text(
                      passwordProvider.displayText,
                      style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          color: passwordProvider.strength <= 1 / 4
                              ? Colors.red
                              : passwordProvider.strength <= 2 / 4
                                  ? Colors.yellow
                                  : passwordProvider.strength <= 3 / 4
                                      ? Colors.blue
                                      : Colors.green),
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: CreateButton(
                            handleButton: () {
                              _handlePasswordChange(passwordProvider.strength);
                            },
                            title: "Change Password"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
