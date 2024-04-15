import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InputTextField extends StatelessWidget {
  final String textHint;
  final String title;
  final String imageUrl;

  final TextEditingController controller;
  final Function validatorFunction;

  const InputTextField({
    super.key,
    required this.controller,
    required this.textHint,
    required this.title,
    required this.imageUrl,
    required this.validatorFunction,
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
          controller: controller,
          onChanged: (value) {},
          validator: (value) {
            return validatorFunction(value);
          },
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

            // floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      )
    ]);
  }
}
