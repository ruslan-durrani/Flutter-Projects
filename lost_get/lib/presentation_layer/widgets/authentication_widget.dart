import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/presentation_layer/screens/Authentication/ResetPassword/reset_password_screen.dart';
import 'package:provider/provider.dart';

import '../../common/constants/colors.dart';

Widget headingText(context, String title) {
  return Text(
    title,
    style: Theme.of(context).textTheme.titleLarge,
  );
}

Widget createCheckboxNecessaryItems(
  context,
) {
  return Consumer(
    builder: (context, ChangeThemeMode value, child) => Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, ResetPassword.routeName),
          child: Text(
            "Forgot password?",
            style: GoogleFonts.roboto(
                fontSize: 13.sp,
                color: AppColors.primaryColor,
                fontWeight:
                    value.isDyslexia ? FontWeight.w900 : FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

Widget createRichTextForLoginSignUp(
  context,
  String description,
  String whereTo,
  Function navigateTo,
) {
  // final state = context.read<SignInBloc>().state;
  return Consumer(
    builder: (context, ChangeThemeMode value, child) => Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(description, style: Theme.of(context).textTheme.bodySmall),
          InkWell(
            onTap: () => navigateTo(),
            child: Text(
              whereTo,
              style: GoogleFonts.roboto(
                fontSize: 13.sp,
                color: AppColors.primaryColor,
                fontWeight:
                    value.isDyslexia ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
