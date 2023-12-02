import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TodoListTile extends StatelessWidget {
  TodoListTile({super.key, required this.title, required this.isChecked,required this.onChanged});
  final String title ;
  final bool isChecked ;
  Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size.width * .9,
      padding:  EdgeInsets.all(12),
      margin: const  EdgeInsets.only(top: 20,bottom: 0,left: 20,right: 20),
      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8)
      ),
      child:  Row(
        children: [
          Checkbox(value: isChecked, onChanged: onChanged,side: BorderSide(color: Colors.white,width: 2),activeColor: colorScheme.inversePrimary,),
          Text(title,style: TextStyle(color: Colors.black,fontSize: 15,decoration: isChecked?TextDecoration.lineThrough:TextDecoration.none),),
        ],
      ),
    );
  }
}
