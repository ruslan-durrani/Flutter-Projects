import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus_meet/theme/colours.dart';
import 'package:nexus_meet/theme/paddings.dart';

class CustomeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  CustomeButton({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal
          ),
        ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
          padding: EdgeInsets.all(buttonPad),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: buttonColor)
      )
      ),

    );
  }
}
