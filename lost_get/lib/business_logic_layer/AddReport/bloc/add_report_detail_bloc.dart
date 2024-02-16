import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_get/data_store_layer/repository/report_item_repository.dart';
import 'package:lost_get/models/report_item.dart';

part 'add_report_detail_event.dart';
part 'add_report_detail_state.dart';

class AddReportDetailBloc
    extends Bloc<AddReportDetailEvent, AddReportDetailState> {
  AddReportDetailBloc() : super(AddReportDetailInitial()) {
    on<ItemReportStatusToggleEvent>(itemReportStatusToggleEvent);
    on<ChangesMadeEvent>(changesMadeEvent);
    on<PublishButtonClickedEvent>(publishButtonClickedEvent);
  }

  FutureOr<void> itemReportStatusToggleEvent(
      ItemReportStatusToggleEvent event, Emitter<AddReportDetailState> emit) {
    emit(ItemReportStatusToggleState());
  }

  FutureOr<void> changesMadeEvent(
      ChangesMadeEvent event, Emitter<AddReportDetailState> emit) {
    emit(ChangesMadeState());
  }

  Future<FutureOr<void>> publishButtonClickedEvent(
      PublishButtonClickedEvent event,
      Emitter<AddReportDetailState> emit) async {
    emit(LoadingState());

    ReportItemRepository addReportRepository = ReportItemRepository();
    List<String> imagesUrl =
        await addReportRepository.uploadImages(event.imageFiles);

    event.reportItemModel.imageUrls = imagesUrl;
    bool result =
        await addReportRepository.publishReport(event.reportItemModel);
    if (result) {
      emit(SuccessState());
    } else {
      emit(ErrorState());
    }
  }
}
