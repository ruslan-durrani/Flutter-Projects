part of 'modify_report_bloc.dart';

sealed class ModifyReportEvent extends Equatable {
  const ModifyReportEvent();

  @override
  List<Object> get props => [];
}

class ModifyReportLoadingEvent extends ModifyReportEvent {
  final String reportId;

  const ModifyReportLoadingEvent({required this.reportId});
}

class LoadingErrorEvent extends ModifyReportEvent {}

class LoadingSuccessEvent extends ModifyReportEvent {}

class ItemReportStatusToggleEvent extends ModifyReportEvent {
  final int index;

  const ItemReportStatusToggleEvent({required this.index});
}

class ChangesMadeEvent extends ModifyReportEvent {}

class UpdateReportEvent extends ModifyReportEvent {
  final String reportId;
  final String? status;
  final GeoPoint? coordinates;
  final String? country;
  final String? city;
  final String? address;
  final String? title;
  final String? description;

  const UpdateReportEvent(
      {this.status,
      this.coordinates,
      this.country,
      this.city,
      this.address,
      this.title,
      this.description,
      required this.reportId});
}
