import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/screens/dashboard/dash_board_screen.dart';

import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../controllers/controller_bloc.dart';
import '../../global/routes_navigation/bloc/navigation_bloc.dart';
import '../components/custom_appbar.dart';
import '../components/drawer_menu.dart';

class DashBoardPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: DrawerMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: DrawerMenu(),
              ),
            Expanded(
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(appPadding),
                  child: Column(
                    children: [
                      CustomAppbar(),
                      SizedBox(
                        height: appPadding,
                      ),
                      BlocBuilder<NavigationBloc, NavigationState>(
                        builder: (context, state) {
                          print(state.currentNavigationItem);

                          return state.screen;
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
