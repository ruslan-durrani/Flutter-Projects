import 'package:flutter/cupertino.dart';

class GetLabel extends StatelessWidget {
  final String label;
  bool isBold;
  GetLabel({
    super.key,
    required this.label,
    this.isBold = false

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 2),
      child: Container(
        // width: double.maxFinite,
        child: Text(
          textAlign:TextAlign.left,
          label,style: TextStyle(fontWeight: isBold?FontWeight.bold:FontWeight.normal,fontSize: 14,),),
      ),
    );
  }
}
