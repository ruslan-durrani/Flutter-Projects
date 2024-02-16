import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/business_logic_layer/ProfileSettings/Settings/ManageAccount/ChangePhoneNumber/ChangePhoneNumberVerified/cubit/change_phone_number_verified_cubit.dart';
import 'package:lost_get/presentation_layer/widgets/authentication_widget.dart';
import 'package:lost_get/presentation_layer/widgets/button.dart';

class ChangePasswordVerifiedScreen extends StatelessWidget {
  const ChangePasswordVerifiedScreen({super.key});
  static const routeName = '/change_password_verified';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/icons/phone_verification_bg.svg',
                fit: BoxFit.cover,
                width: MediaQuery.sizeOf(context).width,
              ),
              Positioned.fill(
                bottom: 30,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                        'assets/icons/phone_verification_check.svg')),
              ),
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          Center(
            child: headingText(context, "Password Changed"),
          ),
          SizedBox(
            height: 3.h,
          ),
          Center(
            child: Text(
              "Your password has been changed successfully.",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: CreateButton(
                  handleButton: () {
                    context
                        .read<ChangePhoneNumberVerifiedCubit>()
                        .navigateToMainMenu(context);
                  },
                  title: "Back To Main Menu"),
            ),
          ))
        ]),
      ),
    );
  }
}
