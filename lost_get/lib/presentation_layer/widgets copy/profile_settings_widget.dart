import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget createListTile(context, String title, String? subtitle,
    String? leadingIcon, Function handleFunction, bool isDark) {
  ColorFilter? colorFilter =
      isDark ? const ColorFilter.mode(Colors.white, BlendMode.srcIn) : null;
  return GestureDetector(
    onTap: () {
      handleFunction();
    },
    child: Column(children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        leading: leadingIcon != null ? SvgPicture.asset(leadingIcon) : null,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: Theme.of(context).textTheme.displaySmall,
              )
            : null,
        trailing: SizedBox(
            child: SvgPicture.asset(
          'assets/icons/arrow-right.svg',
          height: 10.h,
          width: 10.w,
          colorFilter: colorFilter,
        )),
      ),
      Divider(
        color: Colors.grey.withOpacity(0.2),
        height: 1,
        thickness: 1,
      )
    ]),
  );
}
