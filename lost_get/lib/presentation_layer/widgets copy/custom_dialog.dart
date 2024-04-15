import 'package:flutter/material.dart';
import 'package:lost_get/presentation_layer/widgets/please_wait.dart';

OverlayEntry? _overlayEntry;

void showCustomLoadingDialog(BuildContext context, String title) {
  _overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Positioned.fill(
        child: Container(
          color: Colors.transparent
              .withOpacity(0.7), // Make the overlay transparent
          child: Center(
            child: PleaseWaitDialog(description: title),
          ),
        ),
      );
    },
  );

  Overlay.of(context).insert(_overlayEntry!);
}

void hideCustomLoadingDialog(BuildContext context) {
  if (_overlayEntry != null) {
    _overlayEntry!.remove();
    _overlayEntry = null;
  }
}
