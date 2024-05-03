import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruslanbabar/utils/responsive.dart';
import 'widgets/get_persistent_navigator.dart';

class PortfolioView extends StatelessWidget {
  Widget child;
  PortfolioView({super.key, required this.child});

  @override
  Widget build(BuildContext context, ) {
    return Scaffold(
      body: Row(
        children: [
           Responsive.isDesktop(context)?Expanded(
              flex: 2,
              child: GetPersistentNavigator()
          ):Container(),
          Expanded(
            flex: 10,
              child: child),
        ],
      ),
    );
  }
}
