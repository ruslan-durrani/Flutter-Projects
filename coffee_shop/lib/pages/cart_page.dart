import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/coffee_tile.dart';
import '../models/CoffeeShop.dart';
import '../models/coffee.dart';

class CartPage extends StatefulWidget {
  static String routName = "/cart_page";
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  removeFromCart(Coffee coffee){
    Provider.of<CoffeeShop>(context, listen: false).removeItemFromCart(coffee);
  }

  void payForCoffee(){
    // Add Business Logic For you app TODO
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeShop>(
        builder: (context,value,child)=>
            SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Cart",style: TextStyle(
                          fontSize: 18,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.inversePrimary
                      ),
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                            itemCount: value.userCart.length,
                            itemBuilder: (context,index){
                              Coffee eachCoffee = value.userCart[index]["coffee"];
                              int count = value.userCart[index]["count"];
                              return CoffeeTile(coffee: eachCoffee, onPressed:()=>removeFromCart(eachCoffee), icon: Icons.remove,itemCount: count,);
                            }
                        ),
                      ),
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          alignment: Alignment.center,
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
                )
            )
    );
  }
}
