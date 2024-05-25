import 'package:flutter/material.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';

class HelperButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final Color? color;
  final bool isPrimary;
  const HelperButton(
      {super.key, required this.name, required this.onTap, this.color, required this.isPrimary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isPrimary?EColors.primaryColor:Colors.white.withOpacity(0.0),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2,color: EColors.primaryColor)
          ),
          child: Center(
            child: Text(
              name,
              style:  TextStyle(color: isPrimary?Colors.white:EColors.primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}
