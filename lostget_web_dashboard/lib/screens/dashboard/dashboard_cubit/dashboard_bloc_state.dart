
import '../../../business_models/analytic_info_model.dart';
import '../../../constants/constants.dart';

abstract class DashboardAnalyticsState {}

class DashboardAnalyticsLoadingState extends DashboardAnalyticsState {}

class DashboardAnalyticsDataLoadedState extends DashboardAnalyticsState {
  List analytics=[];
  DashboardAnalyticsDataLoadedState(int userCount, int lostItems, int foundItems,  double recoveryRate){
    this.analytics = [
      AnalyticInfo(
        title: "Lost Items",
        count: userCount,
        svgSrc: "assets/icons/Subscribers.svg",
        color: primaryColor,
      ),
      AnalyticInfo(
        title: "Found Items",
        count: foundItems,
        svgSrc: "assets/icons/Post.svg",
        color: purple,
      ),
      AnalyticInfo(
        title: "Recovery Rate",
        count: recoveryRate,
        svgSrc: "assets/icons/Pages.svg",
        color: orange,
      ),
      AnalyticInfo(
        title: "LostGet Users",
        count: lostItems,
        svgSrc: "assets/icons/Comments.svg",
        color: green,
      ),
    ];
  }


}


class DashboardAnalyticsErrorState extends DashboardAnalyticsState {
  final String error;

  DashboardAnalyticsErrorState(this.error);
}

