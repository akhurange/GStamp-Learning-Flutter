import 'package:flutter/material.dart';

import 'max_width_container.dart';


class ProgressDialog {
  final BuildContext context;
  final String message;
  bool isShowing;

  ProgressDialog(this.context, this.message) : isShowing = false;

  void show() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return MaxWidthContainer(
          maxWidth: 500,
          child: Dialog(
            elevation: 12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    isShowing = true;
  }

  void hide() {
    if (!isShowing) {
      return;
    }
    isShowing = false;
    Navigator.pop(context);
  }
}
