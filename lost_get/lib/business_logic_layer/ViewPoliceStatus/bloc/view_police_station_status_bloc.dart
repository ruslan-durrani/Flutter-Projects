import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/presentation_layer/screens/Profile%20Settings/ViewPoliceStatus/Controller/police_station_controller.dart';

part 'view_police_station_status_event.dart';
part 'view_police_station_status_state.dart';

class ViewPoliceStationStatusBloc
    extends Bloc<ViewPoliceStationStatusEvent, ViewPoliceStationStatusState> {
  static final PoliceStationStatusController _policeStationStatusController =
      PoliceStationStatusController();
  ViewPoliceStationStatusBloc() : super(ViewPoliceStationStatusInitial()) {
    on<ReportsLoadEvent>(reportsLoadEvent);
  }

  Future<FutureOr<void>> reportsLoadEvent(ReportsLoadEvent event,
      Emitter<ViewPoliceStationStatusState> emit) async {
    try {
      emit(LoadingState());
      List<ReportItemModel> userReports =
          await _policeStationStatusController.getAllReports();
      print("Reports arrived ${userReports.length}");
      if (userReports.isNotEmpty) {
        emit(PoliceReportsLoadedState(userReports));
      } else {
        emit(PoliceReportsEmptyState());
      }
    } catch (e) {
      emit(ErrorState(msg: e.toString()));
    }
  }
}
