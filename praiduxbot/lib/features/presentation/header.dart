import 'package:flutter/material.dart';

class HeaderBot extends StatelessWidget {
  const HeaderBot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: Colors.deepOrange.withOpacity(.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('./assets/images/logo.png'),
          ),
          SizedBox(width: 10,),

          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(30),

                ),
                padding: EdgeInsets.all(8),
                child: Text("Avatar Chat",style: TextStyle(color: Colors.white),),
              ),
              SizedBox(width: 10,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(30),

                ),
                padding: EdgeInsets.all(8),
                child: Text("Text Chat",style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
          
          SizedBox(width: 10,),
          Icon(Icons.info_outlined,color: Colors.black,)
        ],
      ),
    );
  }
}
