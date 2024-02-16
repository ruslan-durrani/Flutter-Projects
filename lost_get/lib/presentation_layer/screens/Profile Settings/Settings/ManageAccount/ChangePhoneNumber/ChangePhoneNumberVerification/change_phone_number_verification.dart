import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePhoneNumber/ChangePhoneNumberVerification/bloc/change_phone_number_verification_bloc.dart';
import 'package:lost_get/controller/Settings/Manage%20Account/ChangePhoneNumber/change_phone_number_controller.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';
import 'package:lost_get/presentation_layer/widgets/custom_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../../../../../../business_logic_layer/Provider/change_theme_mode.dart';
import '../../../../../../../common/constants/colors.dart';
import '../../../../../../widgets/authentication_widget.dart';
import '../ChangePhoneNumberVerified/change_phone_number_verified.dart';

class ChangePhoneNumberVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const ChangePhoneNumberVerificationScreen(
      {super.key, required this.phoneNumber});

  static const routeName = '/change_phone_number_verification';
  @override
  State<ChangePhoneNumberVerificationScreen> createState() =>
      _ChangePhoneNumberVerificationScreenState();
}

class _ChangePhoneNumberVerificationScreenState
    extends State<ChangePhoneNumberVerificationScreen> {
  OtpFieldController otpController = OtpFieldController();
  String otp = "";
  final ChangePhoneNumberVerificationBloc _changePhoneNumberVerificationBloc =
      ChangePhoneNumberVerificationBloc();
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChangeThemeMode>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: provider.isDarkMode() ? Colors.white : Colors.black,
        ),
        centerTitle: true,
      ),
      body: BlocListener<ChangePhoneNumberVerificationBloc,
          ChangePhoneNumberVerificationState>(
        bloc: _changePhoneNumberVerificationBloc,
        listener: (context, state) {
          if (state is VerifyButtonClickedLoadingState) {
            showCustomLoadingDialog(context, "Verifying...");
          }

          if (state is VerifyButtonClickedErrorState) {
            hideCustomLoadingDialog(context);
            createToast(description: state.errorMsg);
          }

          if (state is VerifyButtonClickedSuccessState) {
            hideCustomLoadingDialog(context);
            Navigator.popAndPushNamed(
                context, ChangePhoneNumberVerifiedScreen.routeName);
          }
        },
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 13.h,
                ),
                headingText(context, "Enter Verification"),
                headingText(context, "Code"),
                SizedBox(height: 3.h),
                RichText(
                  text: TextSpan(
                    text:
                        "Enter the code that we have send to your phone number ",
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: widget.phoneNumber,
                        style: GoogleFonts.roboto(
                          fontSize: 13.sp,
                          color: AppColors.primaryColor,
                          fontWeight: provider.isDyslexia
                              ? FontWeight.w900
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.h,
                ),
                OTPTextField(
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    length: 6,
                    outlineBorderRadius: 8,
                    otpFieldStyle: OtpFieldStyle(
                      backgroundColor: provider.isDarkMode()
                          ? Colors.white
                          : AppColors.darkPrimaryColor,
                      borderColor: provider.isDarkMode()
                          ? Colors.white
                          : AppColors.darkPrimaryColor,
                      focusBorderColor: provider.isDarkMode()
                          ? Colors.white
                          : AppColors.darkPrimaryColor,
                    ),

                    // obscureText: true,
                    controller: otpController,
                    fieldStyle: FieldStyle.box,
                    fieldWidth: 52,
                    style: GoogleFonts.roboto(
                      fontWeight: provider.isDyslexia ? FontWeight.w900 : null,
                      fontSize: 17.sp,
                      color: provider.isDarkMode()
                          ? AppColors.darkPrimaryColor
                          : Colors.white,
                    ),
                    onChanged: (pin) {},
                    onCompleted: (pin) {
                      otp = pin;
                    }
                    // style: ,
                    ),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CreateButton(
                      title: "Verify",
                      handleButton: () {
                        if (otp.length < 6) {
                          createToast(description: "Please complete the code");
                        } else {
                          _changePhoneNumberVerificationBloc
                              .add(VerifyButtonClickedEvent(otp: otp));
                        }
                      }),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
