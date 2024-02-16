part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class TriggerAppEvent extends DashboardEvent {
  final int index;

  TriggerAppEvent(this.index);
}
