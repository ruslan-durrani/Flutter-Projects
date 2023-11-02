import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/coffee.dart';

class CoffeeTile extends StatelessWidget {
  Coffee coffee;
  void Function()? onPressed;
  IconData icon;
  int? itemCount;
   CoffeeTile({super.key,required this.coffee, required this.onPressed, required this.icon, this.itemCount });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 25),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5),

      ),
      child: ListTile(
        title: Row(
          children: [
            Text(coffee.name, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold),),
            SizedBox(width: 10,),
            Text(itemCount==null?"":itemCount.toString(),)
          ],
        ),
        subtitle:Text(coffee.price,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.normal)),
        leading: Image(image: AssetImage(coffee.imagePath)),
        trailing: IconButton(onPressed: onPressed, icon:  Icon(icon, color: Theme.of(context).colorScheme.inversePrimary,)),
      ),
    );
  }
}
