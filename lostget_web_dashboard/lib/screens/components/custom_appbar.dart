import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/global/routes_navigation/bloc/navigation_bloc.dart';

import 'package:responsive_admin_dashboard/screens/components/profile_info.dart';
import 'package:responsive_admin_dashboard/screens/components/search_field.dart';
import 'package:provider/provider.dart';

import '../../controllers/controller_bloc.dart';
import '../../global/widgets/screen_status_title.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: ()=>Scaffold.of(context).openDrawer(),
            // onPressed: context.read<ControllerBloc>().state.controlMenu,
            icon: Icon(
              Icons.menu,
              color: textColor.withOpacity(0.5),
            ),
          ),
        Expanded(child: ScreenTitle()),

        ProfileInfo(),
      ],
    );
  }
}
