import 'package:coffee_shop/components/coffee_tile.dart';
import 'package:coffee_shop/models/CoffeeShop.dart';
import 'package:coffee_shop/utility/my_snakbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/coffee.dart';

class ShopPage extends StatefulWidget {
  static String routeName = "/shop_page";
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}
class _ShopPageState extends State<ShopPage> {
  addToCart(Coffee coffee){
    Provider.of<CoffeeShop>(context, listen: false).addToCart(coffee);
    showSnackBar(context,"Item added successfully");
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
                      Text("Get your coffee?",style: TextStyle(
                          fontSize: 18,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.inversePrimary
                      ),
                      ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                            itemCount: value.coffeeSaleList.length,
                            itemBuilder: (context,index){
                              Coffee eachCoffee = value.coffeeSaleList[index];
                              return CoffeeTile(coffee: eachCoffee, onPressed:()=> addToCart(eachCoffee), icon: Icons.add,);
                            }
                            ),
                      ),
                    ],
                  ),
                ),
            )
    );
  }
}
