import 'package:coffee_shop/components/coffee_tile.dart';
import 'package:coffee_shop/components/my_coffee_add_button.dart';
import 'package:coffee_shop/models/CoffeeShop.dart';
import 'package:coffee_shop/pages/CoffeeAddForm.dart';
import 'package:coffee_shop/pages/CoffeeDetailPage.dart';
import 'package:coffee_shop/utility/my_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_appbar.dart';
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
  void onAddCoffeePressed(){
    showDialog(context: context, builder: (context){
      var colorScheme = Theme.of(context).colorScheme;
      return AddCoffeeForm();
    });
  }
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Consumer<CoffeeShop>(
        builder: (context,value,child)=>
            Scaffold(
              backgroundColor: colorScheme.background,
              appBar: getAppBar(context,colorScheme,"Get you coffee?"),
              floatingActionButton: getMyCoffeeAddButton(context,colorScheme,onAddCoffeePressed),
              body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: value.coffeeSaleList.length,
                              itemBuilder: (context,index){
                                Coffee eachCoffee = value.coffeeSaleList[index];
                                return GestureDetector(
                                  onTap: ()=>Navigator.pushNamed(context, CoffeeDetailsPage.routeName),
                                    child: CoffeeTile(coffee: eachCoffee, onPressed:()=> addToCart(eachCoffee), icon: Icons.add,)
                                );
                              }
                              ),
                        ),
                      ],
                    ),
                  ),
              ),
            )
    );
  }
}
