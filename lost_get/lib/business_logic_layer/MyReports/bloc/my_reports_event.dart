part of 'my_reports_bloc.dart';

sealed class MyReportsEvent extends Equatable {
  const MyReportsEvent();

  @override
  List<Object> get props => [];
}

class MyReportsLoadEvent extends MyReportsEvent {}

class DeactivateReportEvent extends MyReportsEvent {
  final String itemId;

  const DeactivateReportEvent({required this.itemId});
}

class MarkAsRecoveredReportEvent extends MyReportsEvent {
  final String itemId;

  const MarkAsRecoveredReportEvent({required this.itemId});
}

class StartAIMatchMakingEvent extends MyReportsEvent {
  final String id;
  final String uid;

  const StartAIMatchMakingEvent({required this.id, required this.uid});
}

class ButtonPressedEvent extends MyReportsEvent {}
