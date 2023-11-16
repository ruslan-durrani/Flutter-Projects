import 'package:coffee_shop/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  static String routeName = "/welcome_page"; 
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Image.asset("./assets/expresso.png",scale: 4,),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text("Brew Day",style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 2,fontSize: 22,color: Theme.of(context).colorScheme.inversePrimary),),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text("How do you like your coffee?",style: TextStyle(fontWeight: FontWeight.normal,letterSpacing: 2,fontSize: 13,color: Theme.of(context).colorScheme.inversePrimary),),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacementNamed(context, HomePage.routeName);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Text("Pay",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold,fontSize: 17),),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(padding: EdgeInsets.all(30),child: Text("Ruslan · Flutter",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),)
        ],
      ),
    );
  }
}
