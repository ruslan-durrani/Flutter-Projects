import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../routes_navigation/bloc/navigation_bloc.dart';

Widget ScreenTitle() {
  return BlocBuilder<NavigationBloc, NavigationState>(
    builder: (context, state) {
      return Container(
        child: Text(
          "${state.currentNavigationItem}",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      );
    },
  );
}
