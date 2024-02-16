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
