import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/data_store_layer/repository/report_item_repository.dart';
import 'package:lost_get/models/report_item.dart';

part 'qr_code_scanner_event.dart';
part 'qr_code_scanner_state.dart';

class QrCodeScannerBloc extends Bloc<QrCodeScannerEvent, QrCodeScannerState> {
  QrCodeScannerBloc() : super(QrCodeScannerInitial()) {
    on<ScanQREvent>(scanQREvent);
  }

  Future<FutureOr<void>> scanQREvent(
      ScanQREvent event, Emitter<QrCodeScannerState> emit) async {
    emit(QrLoadingState());
    final ReportItemRepository reportItemRepository = ReportItemRepository();

    final ReportItemModel? reportData =
        await reportItemRepository.getAUserReport(event.itemId);

    try {
      if (reportData != null) {
        emit(QrSuccessState(item: reportData));
      } else {
        emit(QrErrorState(msg: "Report not found"));
      }
    } catch (e) {
      emit(QrErrorState(msg: e.toString()));
    }
  }
}
