part of 'qr_code_scanner_bloc.dart';

sealed class QrCodeScannerEvent extends Equatable {
  const QrCodeScannerEvent();

  @override
  List<Object> get props => [];
}

class ScanQREvent extends QrCodeScannerEvent {
  final String itemId;

  ScanQREvent({required this.itemId});
}

class QRSuccessEvent extends QrCodeScannerEvent {}

class QRErrorEvent extends QrCodeScannerEvent {}
