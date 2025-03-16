import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
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

  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
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

  static String formatSeatList(List<String> seats) {
    List<String> upperCaseSeats = seats.map((s) => s.toUpperCase()).toList();
    if (upperCaseSeats.length <= 1) return upperCaseSeats.join();
    return "${upperCaseSeats.sublist(0, upperCaseSeats.length - 1).join(', ')} & ${upperCaseSeats.last}";
  }

  static String generateFirestoreDocId(String email) {
    String username = email.split('@')[0]; // Extract username before '@'
    String randomDigits = (1000 + Random().nextInt(9000))
        .toString(); // Generate 4-digit random number
    return "$username-$randomDigits";
  }

  static String formatTicketDetails({
    required String trainName,
    required String departureDate,
    required String departureTime,
    required String arrivalTime,
    required String from,
    required String to,
    required List<String> selectedSeatList,
    required String coachNo,
  }) {
    return "$trainName | $departureDate | $departureTime - $arrivalTime | $from → $to | Coach $coachNo | Seat(s): ${selectedSeatList.map((seat) => seat.toUpperCase()).join(", ")}";
  }

  static String uint8ListToBase64(Uint8List data) {
    String base64String = base64Encode(data);
    return "data:image/png;base64,$base64String"; // Change to image/jpeg if needed
  }
}
