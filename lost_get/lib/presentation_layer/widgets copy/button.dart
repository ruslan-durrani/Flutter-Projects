import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:provider/provider.dart';

class CreateButton extends StatelessWidget {
  final String title;
  final VoidCallback? handleButton;
  const CreateButton({
    super.key,
    required this.title,
    required this.handleButton,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer(
      builder: (context, ChangeThemeMode value, child) => SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: ElevatedButton(
          onPressed: handleButton,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(15)),
          child: Text(
            title,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight:
                  value.isDyslexia ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
