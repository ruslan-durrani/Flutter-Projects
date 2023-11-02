import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'coffee.dart';

class CoffeeShop extends ChangeNotifier{
  List<Coffee> coffeeSaleList = [
    Coffee(name: "Expresso", price: "100\$", imagePath: "./assets/expresso.png"),
    Coffee(name: "Iced Coffee", price: "300\$", imagePath: "./assets/iced-coffee.png"),
    Coffee(name: "Black Latte", price: "150\$", imagePath: "./assets/latte.png"),
    Coffee(name: "Long Black", price: "150\$", imagePath: "./assets/expresso.png"),
  ];

  List<Map<String,dynamic>> _userCart = [];
  List<Map<dynamic,dynamic>> get userCart => _userCart;
  List<Coffee> get coffeeShop => coffeeSaleList;

  void addToCart(Coffee coffee){
    bool found = false;

    for (var element in _userCart) {
      if (element["coffee"].name == coffee.name) {
        element["count"] = element["count"] + 1;
        found = true;
        break;
      }
    }

    if (!found) {
      _userCart.add({"coffee": coffee, "count": 1});
    }
    notifyListeners();
  }
  void removeItemFromCart(Coffee coffee){
    for (var element in userCart) {
      if(element["coffee"] == coffee){
        userCart.remove(element);
        break;
      }
    }
    notifyListeners();
  }
}