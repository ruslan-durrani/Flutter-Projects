import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PasswordField extends StatelessWidget {
  final String textHint;
  final String title;
  final String imageUrl;
  final bool isHidden;
  final Function toggleEye;

  final TextEditingController controller;
  final Function? handleValidator;
  final Function? handleOnChange;

  const PasswordField({
    super.key,
    required this.textHint,
    required this.title,
    required this.imageUrl,
    required this.isHidden,
    required this.toggleEye,
    required this.controller,
    this.handleValidator,
    this.handleOnChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      const SizedBox(
        height: 6,
      ),
      SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: TextFormField(
          onChanged:
              handleOnChange != null ? (value) => handleOnChange!(value) : null,
          controller: controller,
          validator: handleValidator != null
              ? (value) => handleValidator!(value)
              : null,
          style: Theme.of(context).textTheme.bodySmall,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                imageUrl,
                height: 10.h,
                width: 10.w,
              ),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            hintText: textHint,
            hintStyle: Theme.of(context).textTheme.bodySmall,
            suffixIcon: IconButton(
                onPressed: () {
                  toggleEye();
                },
                icon: isHidden
                    ? SvgPicture.asset(
                        'assets/icons/eye-off.svg',
                        height: 10.h,
                        width: 10.w,
                      )
                    : SvgPicture.asset(
                        'assets/icons/eye-on.svg',
                        height: 10.h,
                        width: 10.w,
                      )),

            // floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          obscureText: isHidden,
        ),
      )
    ]);
  }
}
