import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nexus_meet/theme/colours.dart';

class HomeMeetingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;

  HomeMeetingButton({super.key, required this.onPressed, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity( 0.06),
                  offset: const Offset(0, 4)
                )
              ]
            ),
            child: Icon(icon,color: Colors.white,size: 30,),
          ),
          SizedBox(height: 5,),
          Text(text,style: TextStyle(fontSize: 12,color: Colors.grey),)
        ],
      ),
    );
  }
}
