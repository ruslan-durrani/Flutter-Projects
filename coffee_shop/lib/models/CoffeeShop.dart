import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'coffee.dart';

class CoffeeShop extends ChangeNotifier{
  List<Coffee> coffeeSaleList = [
    Coffee(title: "Expresso", price: "100\$", imageUrl: "./assets/expresso.png", description: 'This is expressos\'s descriptions', category: 'Expresso', quantity: '10'),
    Coffee(title: "Iced Coffee", price: "300\$", imageUrl: "./assets/iced-coffee.png", description: '', category: 'Ice', quantity: '10'),
    Coffee(title: "Black Latte", price: "150\$", imageUrl: "./assets/latte.png", description: 'Latu', category: 'Latte', quantity: '10'),
    Coffee(title: "Long Black", price: "150\$", imageUrl: "./assets/expresso.png", description: 'this is expresso', category: 'Expresso', quantity: '10'),
  ];

  List<Map<String,dynamic>> _userCart = [];
  List<Map<dynamic,dynamic>> get userCart => _userCart;
  List<Coffee> get coffeeShop => coffeeSaleList;

  void addToCart(Coffee coffee){
    bool found = false;

    for (var element in _userCart) {
      if (element["coffee"].title == coffee.title) {
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