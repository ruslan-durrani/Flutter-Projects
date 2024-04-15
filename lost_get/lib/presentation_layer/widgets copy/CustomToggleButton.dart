import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lost_get/business_logic_layer/Provider/modify_report_provider.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CustomToggleButton extends StatefulWidget {
  String initialSelect;

  CustomToggleButton({super.key, required this.initialSelect});

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late List<bool> statusIsSelected;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<ModifyReportProvider>().setStatus(
          widget.initialSelect == 'Lost' ? [true, false] : [false, true]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    statusIsSelected = context.watch<ModifyReportProvider>().status;
    return ToggleButtons(
      borderColor: Colors.grey,
      fillColor: Colors.transparent,
      borderWidth: 1,
      selectedBorderColor: AppColors.primaryColor,
      selectedColor: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(5),
      onPressed: (int index) {
        for (int i = 0; i < statusIsSelected.length; i++) {
          statusIsSelected[i] = i == index;
        }
        context.read<ModifyReportProvider>().setStatus(statusIsSelected);
      },
      isSelected: statusIsSelected,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .445,
          child: const Text('Lost',
              style: TextStyle(fontSize: 16)),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * .445,
          child: const Text('Found',
              style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}
