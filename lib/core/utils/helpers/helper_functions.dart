import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class HelperFunctions {
  // Date Formatter
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Date Formatter 2
  static String formatDate2(String date) {
    DateTime date2 = DateFormat("d/M/y").parse(date);
    return DateFormat("d MMM y").format(date2);
  }

  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, "0");
    final min = time.minute.toString().padLeft(2, "0");
    final sec = time.second.toString().padLeft(2, "0");
    return "$hour:$min:$sec";
  }

  static String formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: 'RM');
    return format.format(amount);
  }

  static double parseCurrency(String formattedPrice) {
    final format = NumberFormat.currency(locale: 'en_US', symbol: 'RM');
    return format.parse(formattedPrice).toDouble();
  }

  static showToast(BuildContext context, String message,
      ToastificationType type, IconData icon) {
    toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      icon: Icon(icon),
      context: context, // optional if you use ToastificationWrapper
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  static showErrorMessage(bool isError, String message) {
    return isError
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  message,
                  style: const TextStyle(color: CupertinoColors.systemRed),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
