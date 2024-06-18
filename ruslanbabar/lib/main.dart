

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruslanbabar/theme.dart';
import 'package:ruslanbabar/views/about/about_view.dart';
import 'package:ruslanbabar/views/portfolio/portfolio_view.dart';
import 'package:ruslanbabar/views/services/services_view.dart';
import 'views/Projects/projects_view.dart';
import 'views/contact/contact_view.dart';
import 'views/home/home_view.dart';
void main()=>runApp(StartApp());
class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        ShellRoute(
          builder: (context, state, child) => PortfolioView(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => HomeView(),

            ),
            GoRoute(
              path: '/about',
              builder: (context, state) => AboutView(),
            ),
            GoRoute(
              path: '/services',
              builder: (context, state) => ServicesView(),
            ),
            GoRoute(
              path: '/projects',
              builder: (context, state) => ProjectsView(),
            ),
            GoRoute(
              path: '/contacts',
              builder: (context, state) => ContactView(),
            ),
          ],
        ),
      ],
    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RuslanB',
      theme: themeData,
      // darkTheme: darkThemeData,
      // themeMode: ThemeMode.system,
      routerConfig: _router,
      // home: HomeView(),
    );
  }
}

