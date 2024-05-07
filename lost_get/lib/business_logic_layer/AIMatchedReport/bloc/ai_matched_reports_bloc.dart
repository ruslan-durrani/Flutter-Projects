import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/data_store_layer/repository/ai_report_item_repository.dart';
import 'package:lost_get/models/matched_reports.dart';
import 'package:lost_get/models/report_item.dart';

part 'ai_matched_reports_event.dart';
part 'ai_matched_reports_state.dart';

class AiMatchedReportsBloc
    extends Bloc<AiMatchedReportsEvent, AiMatchedReportsState> {
  final AIReportItemRepository _aiReportItemRepository =
      AIReportItemRepository();
  AiMatchedReportsBloc() : super(AiMatchedReportsInitial()) {
    on<AIMatchedReportLoadEvent>(aiMatchedReportsLoadEvent);
    on<AIMatchReportAcceptedEvent>(aiMatchReportAcceptedEvent);
    on<AIMatchReportDeclineEvent>(aiMatchReportDeclineEvent);
  }

  Future<void> aiMatchedReportsLoadEvent(
      AiMatchedReportsEvent event, Emitter<AiMatchedReportsState> emit) async {
    emit(AIMatchReportsLoadingState());

    List<ReportItemModel> userReports =
        await _aiReportItemRepository.getUserMatchedReports();
    print("user reports are ${userReports}");
    if (userReports.isNotEmpty) {
      emit(AIMatchedReportsLoadedState(userReports));
    } else {
      emit(AIMatchReportsEmptyState());
    }
  }

  // Make sure to handle completion or cancellation if necessar

  Future<FutureOr<void>> aiMatchReportAcceptedEvent(
      AIMatchReportAcceptedEvent event,
      Emitter<AiMatchedReportsState> emit) async {
    emit(LoadingState());

    bool userReports =
        await _aiReportItemRepository.acceptAIMatchedReport(event.reportId);
    if (userReports) {
      print("i got back");
      emit(AIMatchReportAcceptedState());
    } else {
      print("i got back with error");
      emit(AIMatchMakingErrorState("Report Not Accepted"));
    }
  }

  Future<FutureOr<void>> aiMatchReportDeclineEvent(
      AIMatchReportDeclineEvent event,
      Emitter<AiMatchedReportsState> emit) async {
    emit(LoadingState());

    bool userReports =
        await _aiReportItemRepository.declineUserReport(event.reportId);
    if (userReports) {
      print("i got back");
      emit(AIMatchReportDeclineState());
    } else {
      print("i got back with error");
      emit(AIMatchMakingErrorState("Report Not Declined"));
    }
  }
}
