part of 'add_report_detail_bloc.dart';

sealed class AddReportDetailState extends Equatable {
  const AddReportDetailState();

  @override
  List<Object> get props => [];
}

final class AddReportDetailInitial extends AddReportDetailState {}

final class AddReportDetailActionState extends AddReportDetailState {}

final class ItemReportStatusToggleState extends AddReportDetailState {}

final class ChangesMadeState extends AddReportDetailState {}

final class PublishButtonClickedState extends AddReportDetailActionState {}

final class LoadingState extends AddReportDetailActionState {}

final class ErrorState extends AddReportDetailActionState {}

final class SuccessState extends AddReportDetailActionState {}
