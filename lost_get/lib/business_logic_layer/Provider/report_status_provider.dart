import 'package:flutter/material.dart';
import 'package:lost_get/data_store_layer/repository/ai_report_item_repository.dart';

class ReportStatusProvider with ChangeNotifier {
  bool? isAccepted;

  Future<void> checkReportStatus(
      String reportId, AIReportItemRepository repository) async {
    isAccepted = await repository.checkIsMatchReportAccepted(reportId);
    notifyListeners();
  }
}
