part of 'view_police_station_status_bloc.dart';

sealed class ViewPoliceStationStatusState extends Equatable {
  const ViewPoliceStationStatusState();

  @override
  List<Object> get props => [];
}

final class ViewPoliceStationStatusInitial
    extends ViewPoliceStationStatusState {}

class PoliceStatusActionState extends ViewPoliceStationStatusState {}

class ErrorState extends PoliceStatusActionState {
  final String msg;

  ErrorState({required this.msg});
}

class PoliceReportsLoadedState extends ViewPoliceStationStatusState {
  final List<ReportItemModel> reportItems;

  const PoliceReportsLoadedState(this.reportItems);
}

class PoliceReportsEmptyState extends ViewPoliceStationStatusState {}

class LoadingState extends ViewPoliceStationStatusState {}
