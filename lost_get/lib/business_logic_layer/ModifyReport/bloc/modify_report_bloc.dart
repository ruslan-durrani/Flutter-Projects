import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/data_store_layer/repository/report_item_repository.dart';
import 'package:lost_get/models/report_item.dart';

part 'modify_report_event.dart';
part 'modify_report_state.dart';

class ModifyReportBloc extends Bloc<ModifyReportEvent, ModifyReportState> {
  final ReportItemRepository _report = ReportItemRepository();
    ModifyReportBloc() : super(ModifyReportInitial()) {
    on<ModifyReportLoadingEvent>(loadingEvent);
    on<ItemReportStatusToggleEvent>(itemReportStatusToggleEvent);
    on<ChangesMadeEvent>(changesMadeEvent);
    on<UpdateReportEvent>(updateReportEvent);
  }

  Future<FutureOr<void>> loadingEvent(
      ModifyReportLoadingEvent event, Emitter<ModifyReportState> emit) async {
    emit(ModifyReportLoadingState());

    final report = await _report.getAUserReport(event.reportId);
    if (report != null) {
      emit(ModifyReportLoadingSuccessState(report: report));
    } else {
      emit(ModifyReportLoadingErrorState());
    }
  }

  FutureOr<void> itemReportStatusToggleEvent(
      ItemReportStatusToggleEvent event, Emitter<ModifyReportState> emit) {
    emit(ItemReportStatusToggleState(index: event.index));
  }

  FutureOr<void> changesMadeEvent(
      ChangesMadeEvent event, Emitter<ModifyReportState> emit) {
    emit(ChangesMadeState());
  }

  Future<FutureOr<void>> updateReportEvent(
      UpdateReportEvent event, Emitter<ModifyReportState> emit) async {
    emit(ReportUpdateLoadingState());

    final bool isUpdated = await _report.updateReport(
        event.reportId,
        event.coordinates,
        event.status,
        event.country,
        event.city,
        event.address,
        event.title,
        event.description);
    if (isUpdated) {
      emit(ReportUpdatedState());
    } else {
      emit(ReportNotUpdatedState());
    }
  }
}
