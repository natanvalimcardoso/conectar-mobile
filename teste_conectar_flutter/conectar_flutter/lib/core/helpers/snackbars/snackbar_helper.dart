import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarHelper {
  static void showSuccess({
    required String title,
    required String subtitle,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      subtitle,
      backgroundColor: backgroundColor ?? Colors.green[100],
      colorText: textColor ?? Colors.green[800],
      snackPosition: position,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  static void showError({
    required String title,
    required String subtitle,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      subtitle,
      backgroundColor: backgroundColor ?? Colors.red[100],
      colorText: textColor ?? Colors.red[800],
      snackPosition: position,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 4),
    );
  }

  static void showInfo({
    required String title,
    required String subtitle,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      subtitle,
      backgroundColor: backgroundColor ?? Colors.blue[100],
      colorText: textColor ?? Colors.blue[800],
      snackPosition: position,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarning({
    required String title,
    required String subtitle,
    Color? backgroundColor,
    Color? textColor,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      subtitle,
      backgroundColor: backgroundColor ?? Colors.orange[100],
      colorText: textColor ?? Colors.orange[800],
      snackPosition: position,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      duration: const Duration(seconds: 3),
    );
  }
} 