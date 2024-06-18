import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruslanbabar/utils/responsive.dart';
import 'widgets/get_persistent_navigator.dart';

class PortfolioView extends StatefulWidget {
  Widget child;
  PortfolioView({super.key, required this.child});

  @override
  State<PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView> {
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
              child: widget.child),
        ],
      ),
    );
  }
}
