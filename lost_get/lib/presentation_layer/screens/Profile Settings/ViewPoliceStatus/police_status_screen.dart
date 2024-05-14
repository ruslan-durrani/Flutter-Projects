import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lost_get/business_logic_layer/ViewPoliceStatus/bloc/view_police_station_status_bloc.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/ViewPoliceStatus/policeStatusCard.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';

class ViewPoliceStatusScreen extends StatefulWidget {
  static const String routeName = "/view_police_station_status";
  const ViewPoliceStatusScreen({super.key});

  @override
  State<ViewPoliceStatusScreen> createState() => _ViewPoliceStatusScreenState();
}

class _ViewPoliceStatusScreenState extends State<ViewPoliceStatusScreen> {
  final ViewPoliceStationStatusBloc policeStatusBloc =
      ViewPoliceStationStatusBloc();

  @override
  void initState() {
    policeStatusBloc.add(ReportsLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Police Station Status",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      body: SafeArea(child: getAllReports()),
    );
  }

  Widget getAllReports() {
    return BlocConsumer<ViewPoliceStationStatusBloc,
        ViewPoliceStationStatusState>(
      bloc: policeStatusBloc,
      listenWhen: (previous, current) => current is PoliceStatusActionState,
      buildWhen: (previous, current) => current is! PoliceStatusActionState,
      listener: (context, state) {
        if (state is ErrorState) {
          createToast(description: state.msg);
        }
      },
      builder: (context, state) {
        if (state is PoliceReportsLoadedState) {
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: state.reportItems.length,
                itemBuilder: (context, index) {
                  final ReportItemModel item = state.reportItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PoliceStatusCard(
                        item: item, policeStatusBloc: policeStatusBloc),
                  );
                },
              )),
            ],
          );
        } else if (state is PoliceReportsEmptyState) {
          return Center(
            child: Text(
              "There are no reports at the moment!",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        } else if (state is LoadingState) {
          return const SpinKitFadingCircle(
            color: AppColors.primaryColor,
            size: 50,
          );
        }
        return Container();
      },
    );
  }
}
