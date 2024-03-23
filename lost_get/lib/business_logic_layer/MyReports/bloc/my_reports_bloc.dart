import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/data_store_layer/repository/report_item_repository.dart';
import 'package:lost_get/models/report_item.dart';

part 'my_reports_event.dart';
part 'my_reports_state.dart';

class MyReportsBloc extends Bloc<MyReportsEvent, MyReportsState> {
  final ReportItemRepository _reportItemRepository = ReportItemRepository();
  MyReportsBloc() : super(MyReportsInitial()) {
    on<MyReportsLoadEvent>(myReportsLoadEvent);
    on<DeactivateReportEvent>(deactivateReportEvent);
    on<MarkAsRecoveredReportEvent>(markAsRecoveredReportEvent);
  }

  Future<FutureOr<void>> myReportsLoadEvent(
      MyReportsLoadEvent event, Emitter<MyReportsState> emit) async {
    try {
      emit(MyReportsLoadingState());
      List<ReportItemModel> userReports =
          await _reportItemRepository.getUserReports();
      if (userReports.isNotEmpty) {
        emit(MyReportsLoadedState(userReports));
      } else {
        emit(MyReportsEmptyState());
      }
    } catch (e) {}
  }

  Future<FutureOr<void>> deactivateReportEvent(
      DeactivateReportEvent event, Emitter<MyReportsState> emit) async {
    emit(LoadingState());
    bool isDeleted = await _reportItemRepository.deleteUserReport(event.itemId);
    if (isDeleted) {
      emit(ReportDeactivatedSuccessfully());
    } else {
      emit(ReportDeactivationError());
    }
  }

  Future<FutureOr<void>> markAsRecoveredReportEvent(
      MarkAsRecoveredReportEvent event, Emitter<MyReportsState> emit) async {
    emit(LoadingState());
    bool isRecovered =
        await _reportItemRepository.markReportAsRecovered(event.itemId);
    if (isRecovered) {
      emit(ReportMarkedAsRecoveredSuccessfullyState());
    } else {
      emit(ReportMarkedAsRecoveredErrorState());
    }
  }
}
