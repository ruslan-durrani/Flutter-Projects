import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lost_get/presentation_layer/screens/My%20Reports/my_reports_screen.dart';
import 'package:lost_get/presentation_layer/screens/Add%20Report/add_report_screen.dart';
import 'package:lost_get/presentation_layer/screens/Messenger/chat_screen.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/profile_settings_screen.dart';
import 'package:lost_get/presentation_layer/screens/Home/home_screen.dart';
import 'package:lost_get/presentation_layer/widgets/navbar.dart';

import '../../../business_logic_layer/Dashboard/bloc/dashboard_bloc.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard_screen';
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardBloc dashboardBloc = DashboardBloc();
  final List<Widget> _fragments = const [
    HomeScreen(),
    ChatScreen(),
    AddReportScreen(),
    MyReportsScreen(),
    ProfileSettings()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      builder: (context, state) {
        return Scaffold(
          body: _fragments[state.index],
          bottomNavigationBar: NavBar(
            dashboardBloc: dashboardBloc,
          ),
        );
      },
    );
  }
}
