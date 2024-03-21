import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/data/data.dart';

import '../dashboard/dashboard_cubit/dashboard_bloc_cubit.dart';
import '../dashboard/dashboard_cubit/dashboard_bloc_state.dart';
import 'analytic_info_card.dart';

class AnalyticCards extends StatelessWidget {
  const AnalyticCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridView(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
        ),
        tablet: AnalyticInfoCardGridView(),
        desktop: AnalyticInfoCardGridView(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatelessWidget {
  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final analyticsBloc = BlocProvider.of<DashboardAnalyticsBloc>(context);
    analyticsBloc.fetchAnalyticsData();
    return BlocBuilder<DashboardAnalyticsBloc, DashboardAnalyticsState>(
      bloc: analyticsBloc,
      builder: (context, state) {
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: analyticData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: appPadding,
            mainAxisSpacing: appPadding,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            if(state is DashboardAnalyticsDataLoadedState){
              return AnalyticInfoCard(
                info: state.analytics[index],
              );
            }

            else{
              return AnalyticInfoCard(
                info: analyticData[index],
              );
            }
          }

        );
      },
    );
  }
}
