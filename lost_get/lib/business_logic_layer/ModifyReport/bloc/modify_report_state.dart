part of 'modify_report_bloc.dart';

sealed class ModifyReportState extends Equatable {
  const ModifyReportState();

  @override
  List<Object> get props => [];
}

final class ModifyReportInitial extends ModifyReportState {}

class ModifyReportActionState extends ModifyReportState {}

class ModifyReportLoadingState extends ModifyReportState {}

class ModifyReportLoadingErrorState extends ModifyReportState {}

class ModifyReportLoadingSuccessState extends ModifyReportState {
  final ReportItemModel report;

  const ModifyReportLoadingSuccessState({required this.report});
}

class ItemReportStatusToggleState extends ModifyReportActionState {
  final int index;

  ItemReportStatusToggleState({required this.index});
}

class ChangesMadeState extends ModifyReportActionState {}

class ReportUpdatedState extends ModifyReportActionState {}

class ReportNotUpdatedState extends ModifyReportActionState {}

class ReportUpdateLoadingState extends ModifyReportActionState {}
