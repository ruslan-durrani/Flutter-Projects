
import 'package:flutter/cupertino.dart';

import '../../constants/constants.dart';

Widget Logo(){
  return Container(
    padding: EdgeInsets.all(appPadding),
    width: 150,
    child: Image(
        image: AssetImage("./assets/images/logo.png")),
  );
}