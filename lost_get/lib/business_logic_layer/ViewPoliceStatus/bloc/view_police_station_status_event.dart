part of 'view_police_station_status_bloc.dart';

sealed class ViewPoliceStationStatusEvent extends Equatable {
  const ViewPoliceStationStatusEvent();

  @override
  List<Object> get props => [];
}

class ReportsLoadEvent extends ViewPoliceStationStatusEvent {}
