import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/data_store_layer/repository/ai_report_item_repository.dart';
import 'package:lost_get/data_store_layer/repository/report_item_repository.dart';
import 'package:lost_get/models/report_item.dart';
import 'package:lost_get/utils/api_services.dart';

part 'my_reports_event.dart';
part 'my_reports_state.dart';

class MyReportsBloc extends Bloc<MyReportsEvent, MyReportsState> {
  final ReportItemRepository _reportItemRepository = ReportItemRepository();

  final AIReportItemRepository _aiReportItemRepository =
      AIReportItemRepository();
  MyReportsBloc() : super(MyReportsInitial()) {
    on<MyReportsLoadEvent>(myReportsLoadEvent);
    on<DeactivateReportEvent>(deactivateReportEvent);
    on<MarkAsRecoveredReportEvent>(markAsRecoveredReportEvent);
    on<StartAIMatchMakingEvent>(startAIMatchMakingEvent);
    on<ButtonPressedEvent>(buttonPressedEvent);
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

  Future<FutureOr<void>> startAIMatchMakingEvent(
      StartAIMatchMakingEvent event, Emitter<MyReportsState> emit) async {
    bool isUserAwaiting =
        await _aiReportItemRepository.isUserReportAwaiting(event.id);
    if (!isUserAwaiting) {
      startAIMatchMaking(id: event.id, uid: event.uid);
      await _reportItemRepository.updateAIStatus(event.id);
      emit(StartAIMatchMakingState());
    } else {
      emit(UserReportsStillAwaitsState());
    }
  }

  FutureOr<void> buttonPressedEvent(
      ButtonPressedEvent event, Emitter<MyReportsState> emit) {
    emit(ButtonPressedState());
  }
}
