import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/global/routes_navigation/models/navigation_model.dart';
import 'package:responsive_admin_dashboard/screens/components/dashboard_content.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../controllers/controller_bloc.dart';
import '../../global/routes_navigation/bloc/navigation_bloc.dart';
import '../components/analytic_cards.dart';
import '../components/custom_appbar.dart';
import '../components/administration_card.dart';
import '../components/drawer_menu.dart';
import '../components/top_referals.dart';
import '../components/users.dart';
import '../components/users_by_device.dart';
import '../components/viewers.dart';
import 'dashboard_pager.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}
class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  AnalyticCards(),
                  SizedBox(
                    height: appPadding,
                  ),
                  Users(),
                  if (Responsive.isMobile(context))
                    SizedBox(
                      height: appPadding,
                    ),
                  if (Responsive.isMobile(context)) Administrations(),
                ],
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(
                width: appPadding,
              ),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: Administrations(),
              ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  SizedBox(
                    height: appPadding,
                  ),
                  Row(
                    children: [
                      if(!Responsive.isMobile(context))
                        Expanded(
                          child: TopReferals(),
                          flex: 2,
                        ),
                      if(!Responsive.isMobile(context))
                        SizedBox(width: appPadding,),
                      Expanded(
                        flex: 3,
                        child: Viewers(),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  SizedBox(
                    height: appPadding,
                  ),
                  if (Responsive.isMobile(context))
                    SizedBox(
                      height: appPadding,
                    ),
                  if (Responsive.isMobile(context)) TopReferals(),
                  if (Responsive.isMobile(context))
                    SizedBox(
                      height: appPadding,
                    ),
                  if (Responsive.isMobile(context)) UsersByDevice(),
                ],
              ),
            ),
            if (!Responsive.isMobile(context))
              SizedBox(
                width: appPadding,
              ),
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: UsersByDevice(),
              ),
          ],
        ),
      ],
    );
  }
}
