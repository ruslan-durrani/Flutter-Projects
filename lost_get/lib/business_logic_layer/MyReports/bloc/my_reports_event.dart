part of 'my_reports_bloc.dart';

sealed class MyReportsEvent extends Equatable {
  const MyReportsEvent();

  @override
  List<Object> get props => [];
}

class MyReportsLoadEvent extends MyReportsEvent {}
