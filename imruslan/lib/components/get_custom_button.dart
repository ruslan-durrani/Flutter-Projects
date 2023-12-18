import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetCustomButton extends StatelessWidget {
  bool cta = false;
  GetCustomButton({super.key, this.cta = false});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 50,
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: !cta?colorScheme.inversePrimary:Colors.blueAccent
      ),
      child: Row(
        children: [
          Text(
            "Contact Me",
            style: TextStyle(fontWeight: FontWeight.normal,color: cta?colorScheme.inversePrimary:colorScheme.primary),
          ),
          SizedBox(width: 10,),
          cta?Icon(Icons.arrow_forward,color: colorScheme.inversePrimary,size: 16,):Container()
        ],
      )
    );
  }
}
