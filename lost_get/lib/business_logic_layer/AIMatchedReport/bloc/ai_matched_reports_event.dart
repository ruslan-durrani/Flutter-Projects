part of 'ai_matched_reports_bloc.dart';

sealed class AiMatchedReportsEvent extends Equatable {
  const AiMatchedReportsEvent();

  @override
  List<Object> get props => [];
}

class AIMatchedReportLoadEvent extends AiMatchedReportsEvent {}

class DeclineReportEvent extends AiMatchedReportsEvent {
  final String itemId;

  const DeclineReportEvent({required this.itemId});
}

class AcceptReportEvent extends AiMatchedReportsEvent {
  final String itemId;

  const AcceptReportEvent({required this.itemId});
}

class AIMatchReportAcceptedEvent extends AiMatchedReportsEvent {
  final String reportId;

  const AIMatchReportAcceptedEvent({required this.reportId});
}

class AIMatchReportDeclineEvent extends AiMatchedReportsEvent {
  final String reportId;

  const AIMatchReportDeclineEvent({required this.reportId});
}
