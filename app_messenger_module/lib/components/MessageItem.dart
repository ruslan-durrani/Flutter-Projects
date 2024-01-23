import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {

  final bool isReceiver;
  final String message;
  MessageItem({super.key,required this.isReceiver,required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(10),
      alignment: isReceiver ? Alignment.centerLeft : Alignment.centerRight,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isReceiver ? Colors.grey.withOpacity(0.2) : Colors.black
      ),
      padding: EdgeInsets.all(10),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: isReceiver ? Colors.black : Colors.white),
        text: message
      ),
        softWrap: true,
      ),
    );
  }
}
