import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final description;
  final text;
  void Function()? onEditPress;
   MyTextBox({super.key,required this.description, required this.text, required this.onEditPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const  EdgeInsets.symmetric(horizontal: 15,vertical: 8),
      padding: const  EdgeInsets.all( 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(7)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text,style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.normal,
                  fontSize: 14
              ),
              ),
              GestureDetector(
                onTap: onEditPress,
                child: Icon(Icons.settings,color: Theme.of(context).colorScheme.secondary,),
              )
            ],
          ),
          const SizedBox(height: 5,),
          Text(description,style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14
          ),),
        ],
      ),
    );
  }
}
