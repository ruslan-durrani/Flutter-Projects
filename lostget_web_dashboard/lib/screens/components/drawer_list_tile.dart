import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';

import '../../global/routes_navigation/bloc/navigation_bloc.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({Key? key, required this.title, required this.svgSrc,required this.widget,})
      : super(key: key);

  // required this.tap
  final String title, svgSrc;

  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    final navBloc = BlocProvider.of<NavigationBloc>(context);
    return BlocBuilder<NavigationBloc, NavigationState>(
      bloc: navBloc,
      builder: (context, state) {
        return InkWell(
          onHover: (value) {},
          onTap: () {
            navBloc.add(OnNavigationClickEvent(title,widget));
          },
          child: ListTile(
            horizontalTitleGap: 4.0,
            leading: SvgPicture.asset(svgSrc, color:navBloc.state.isActive(title)? primaryColor:grey, height: 20,),
            title: Text(title, style: TextStyle(color:navBloc.state.isActive(title)?primaryColor:grey,fontWeight: navBloc.state.isActive(title)?FontWeight.bold:FontWeight.normal),),
          ),
        );
      },
    );
  }
}
