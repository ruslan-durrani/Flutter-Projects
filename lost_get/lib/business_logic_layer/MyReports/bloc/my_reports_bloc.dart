import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_get/data_store_layer/repository/report_item_repository.dart';
import 'package:lost_get/models/report_item.dart';

part 'my_reports_event.dart';
part 'my_reports_state.dart';

class MyReportsBloc extends Bloc<MyReportsEvent, MyReportsState> {
  ReportItemRepository _reportItemRepository = ReportItemRepository();
  MyReportsBloc() : super(MyReportsInitial()) {
    on<MyReportsLoadEvent>(myReportsLoadEvent);
  }

  Future<FutureOr<void>> myReportsLoadEvent(
      MyReportsLoadEvent event, Emitter<MyReportsState> emit) async {
    try {
      List<ReportItemModel> userReports =
          await _reportItemRepository.getUserReports();
      if (userReports.isNotEmpty) {
        emit(MyReportsLoadedState(userReports));
      } else {
        emit(MyReportsEmptyState());
      }
    } catch (e) {}
  }
}
