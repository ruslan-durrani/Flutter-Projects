part of 'add_report_detail_bloc.dart';

sealed class AddReportDetailEvent extends Equatable {
  const AddReportDetailEvent();

  @override
  List<Object> get props => [];
}

final class ItemReportStatusToggleEvent extends AddReportDetailEvent {}

final class ChangesMadeEvent extends AddReportDetailEvent {}

final class PublishButtonClickedEvent extends AddReportDetailEvent {
  final ReportItemModel reportItemModel;
  final List<XFile> imageFiles;

  const PublishButtonClickedEvent(
      {required this.reportItemModel, required this.imageFiles});
}

final class LoadingEvent extends AddReportDetailEvent {}

final class ErrorEvent extends AddReportDetailEvent {}

final class SuccessEvent extends AddReportDetailEvent {}
