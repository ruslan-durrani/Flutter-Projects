part of 'ai_matched_reports_bloc.dart';

sealed class AiMatchedReportsState extends Equatable {
  const AiMatchedReportsState();

  @override
  List<Object> get props => [];
}

final class AiMatchedReportsInitial extends AiMatchedReportsState {}

class AIMatchedReportsLoadingState extends AiMatchedReportsActionState {}

class AiMatchedReportsActionState extends AiMatchedReportsState {}

class AIMatchedReportsLoadedState extends AiMatchedReportsState {
  final List<ReportItemModel> reportItems;

  const AIMatchedReportsLoadedState(this.reportItems);
}

class MyReportsEmptyState extends AiMatchedReportsState {}

class ReportDeactivatedSuccessfully extends AiMatchedReportsActionState {}

class ReportDeactivationError extends AiMatchedReportsActionState {}

class LoadingState extends AiMatchedReportsActionState {}

class ReportMarkedAsRecoveredSuccessfullyState
    extends AiMatchedReportsActionState {}

class ReportMarkedAsRecoveredErrorState extends AiMatchedReportsActionState {}

class StartAIMatchMakingState extends AiMatchedReportsActionState {}

class AIMatchMakingErrorState extends AiMatchedReportsActionState {
  final String msg;

  AIMatchMakingErrorState(this.msg);
}

class AIMatchReportsEmptyState extends AiMatchedReportsState {}

class AIMatchReportsLoadingState extends AiMatchedReportsState {}

class AIMatchReportAcceptedState extends AiMatchedReportsActionState {}

class AIMatchReportDeclineState extends AiMatchedReportsActionState {}
