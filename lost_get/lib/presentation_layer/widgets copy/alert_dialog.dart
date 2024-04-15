import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../../common/constants/colors.dart';
import '../../common/constants/constant.dart';

Future<void> alertDialog(context, String msg, String title, String actionOne,
    String actionTwo, Function noFunction, Function yesFunction) {
      // provider = 
  return Dialogs.materialDialog(
      context: context,
      msg: msg,
      msgStyle: Theme.of(context).textTheme.bodySmall,
      color: AppConstants.isDark ? AppColors.darkPrimaryColor : Colors.white,
      title: title,
      actions: [
        IconsButton(
          onPressed: () {
            noFunction();
          },
          text: actionOne,
          color: Colors.grey,
          iconData: Icons.cancel,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
        IconsButton(
          onPressed: () {
            yesFunction();
          },
          text: actionTwo,
          iconData: Icons.house,
          color: AppColors.primaryColor,
          textStyle: const TextStyle(color: Colors.white),
          iconColor: Colors.white,
        ),
      ]);
}
