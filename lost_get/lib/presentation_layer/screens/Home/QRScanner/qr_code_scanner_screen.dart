import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lost_get/business_logic_layer/Provider/change_theme_mode.dart';
import 'package:lost_get/business_logic_layer/QRCodeScanner/bloc/qr_code_scanner_bloc.dart';
import 'package:lost_get/common/constants/colors.dart';
import 'package:lost_get/presentation_layer/screens/Home/item_detail_screen.dart';
import 'package:lost_get/presentation_layer/widgets/custom_dialog.dart';
import 'package:lost_get/presentation_layer/widgets/toast.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  static const routeName = "/qr_code_scanner_screen";
  const QRCodeScannerScreen({super.key});

  @override
  State<QRCodeScannerScreen> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final QrCodeScannerBloc bloc = QrCodeScannerBloc();

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeThemeMode>(
        builder: (context, ChangeThemeMode value, child) {
      ColorFilter? colorFilter = value.isDarkMode()
          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
          : null;
      return BlocConsumer<QrCodeScannerBloc, QrCodeScannerState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is QrLoadingState) {
            showCustomLoadingDialog(context, "Please Wait...");
          }
          if (state is QrSuccessState) {
            hideCustomLoadingDialog(context);
            Navigator.pushReplacementNamed(context, ItemDetailScreen.routeName,
                arguments: state.item);
          }
          if (state is QrErrorState) {
            hideCustomLoadingDialog(context);
            createToast(description: state.msg);
            controller?.resumeCamera();
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "LostGet QR Code",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 32,
                  height: 32,
                  colorFilter: colorFilter,
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: (controller) =>
                        _onQRViewCreated(controller, bloc),
                    overlay: QrScannerOverlayShape(
                      borderColor: AppColors.primaryColor,
                      borderRadius: 5,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 350,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _onQRViewCreated(QRViewController controller, QrCodeScannerBloc bloc) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();

      final String? itemId = scanData
          .code; // Assume the QR code contains just the item ID as a string

      if (itemId != null && itemId.isNotEmpty) {
        bloc.add(ScanQREvent(itemId: itemId));
      } else {
        createToast(description: "Report not found.");
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
