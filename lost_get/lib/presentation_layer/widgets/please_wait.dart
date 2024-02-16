import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:provider/provider.dart';

class PleaseWaitDialog extends StatelessWidget {
  final String description;
  const PleaseWaitDialog({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ChangeThemeMode value, child) => Container(
        decoration: BoxDecoration(
            color:
                value.isDarkMode() ? AppColors.darkPrimaryColor : Colors.white,
            borderRadius: BorderRadius.circular(6)),
        width: 200.w,
        height: 35.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(), // Circular loading indicator
            const SizedBox(width: 16.0),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ), // Text message
          ],
        ),
      ),
    );
  }
}
