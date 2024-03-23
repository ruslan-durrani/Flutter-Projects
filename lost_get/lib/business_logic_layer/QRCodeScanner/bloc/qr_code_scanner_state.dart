part of 'qr_code_scanner_bloc.dart';

sealed class QrCodeScannerState extends Equatable {
  const QrCodeScannerState();

  @override
  List<Object> get props => [];
}

final class QrCodeScannerInitial extends QrCodeScannerState {}

class QrCodeScannerActionState extends QrCodeScannerState {}

class QrErrorState extends QrCodeScannerActionState {
  final String msg;

  QrErrorState({required this.msg});
}

class QrSuccessState extends QrCodeScannerActionState {
  final ReportItemModel item;

  QrSuccessState({required this.item});
}

class QrLoadingState extends QrCodeScannerActionState {}
