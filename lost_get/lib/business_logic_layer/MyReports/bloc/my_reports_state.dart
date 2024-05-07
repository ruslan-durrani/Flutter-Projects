part of 'my_reports_bloc.dart';

sealed class MyReportsState extends Equatable {
  const MyReportsState();

  @override
  List<Object> get props => [];
}

final class MyReportsInitial extends MyReportsState {}

class MyReportsLoadingState extends MyReportsState {}

class MyReportsActionState extends MyReportsState {}

class MyReportsLoadedState extends MyReportsState {
  final List<ReportItemModel> reportItems;

  const MyReportsLoadedState(this.reportItems);
}

class MyReportsEmptyState extends MyReportsState {}

class ReportDeactivatedSuccessfully extends MyReportsActionState {}

class ReportDeactivationError extends MyReportsActionState {}

class LoadingState extends MyReportsActionState {}

class ReportMarkedAsRecoveredSuccessfullyState extends MyReportsActionState {}

class ReportMarkedAsRecoveredErrorState extends MyReportsActionState {}

class StartAIMatchMakingState extends MyReportsActionState {}

class AIMatchMakingErrorState extends MyReportsActionState {}

class UserReportsStillAwaitsState extends MyReportsActionState {}

class ButtonPressedState extends MyReportsActionState {}
