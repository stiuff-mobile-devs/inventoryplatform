import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogs {
  static void showLoadingDialog(String message, {Color color = Colors.amber}) {
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void showSuccessDialog(String message) {
    showLoadingDialog(message, color: Colors.green);
  }

  static void showErrorDialog(String message) {
    showLoadingDialog(message, color: Colors.red);
  }

  static void showInfoDialog(String message) {
    showLoadingDialog(message, color: Colors.amber);
  }

  static void closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}