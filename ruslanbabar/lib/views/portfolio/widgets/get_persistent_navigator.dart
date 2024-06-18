import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruslanbabar/views/home/widgets/top_profile_info.dart';

import 'nav_buttons.dart';

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}

class GetPersistentNavigator extends StatefulWidget {
  const GetPersistentNavigator( {super.key});

  @override
  State<GetPersistentNavigator> createState() => _GetPersistentNavigatorState();
}

class _GetPersistentNavigatorState extends State<GetPersistentNavigator> {
  Map<String,String> navItems = {
      "Home":"/",
      "About":"/about",
      "Services":"/services",
      "Projects":"/projects",
      "Contact":"/contacts",
    };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary
        ),
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: Column(
            children: [
              TopProfileInfo(),
              Divider(color: Theme.of(context).colorScheme.inverseSurface.withOpacity(.05),),
              NavButton(
                label: 'Home',
                isSelected: GoRouter.of(context).location() == '/',
                onPressed: () => {
                  setState(() {
                  context.go('/');
                })} ,
              ),
              NavButton(
                label: 'About',
                isSelected: GoRouter.of(context).location() == '/about',
                onPressed: () {setState(() {
                  context.go('/about');
                });},
              ),
              NavButton(
                label: 'Services',
                isSelected: GoRouter.of(context).location() == '/services',
                onPressed: () {
                  setState(() {
                    context.go('/services');
                  });
                },
              ),
              NavButton(
                label: 'Projects',
                isSelected: GoRouter.of(context).location() == '/projects',
                onPressed: () {
                  setState(() {
                    context.go('/projects');
                  });
                },
              ),
              Divider(color: Theme.of(context).colorScheme.inverseSurface.withOpacity(.05),),
              NavButton(
                label: 'Contact',
                isSelected: GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString() == '/contact',
                onPressed: (){
                  setState(() {
                    context.go('/contacts');
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
