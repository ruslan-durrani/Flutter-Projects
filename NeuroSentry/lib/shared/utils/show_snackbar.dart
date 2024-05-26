import 'package:flutter/material.dart';
import 'package:mental_healthapp/shared/constants/colors.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
  bool isError = false,
  Color backgroundColor = EColors.primarybg,
  Duration duration = const Duration(seconds: 3),
}) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, -1),
          end: Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: AnimationController(
              duration: Duration(milliseconds: 300),
              vsync: Navigator.of(context),
            )..forward(),
            curve: Curves.easeOut,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45.withOpacity(.7),
                  blurRadius: 8.0,
                  spreadRadius: 1.0,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
                    color: isError ? Colors.red : Colors.green,
                    size: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      content,
                      style: TextStyle(
                        color: EColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // Add the overlay to the widget tree
  Overlay.of(context)?.insert(overlayEntry);

  // Automatically remove the overlay after the duration
  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}

// Usage example
void someFunction(BuildContext context) {
  showSnackBar(
    context: context,
    content: "Your action was successful!",
    isError: false,
  );
}
