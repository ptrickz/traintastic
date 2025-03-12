class HelperFunctions {
  // Date Formatter
  static String formatDate(DateTime date) {
    return '${date.year}/${date.month}/${date.day}';
  }

  static String formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, "0");
    final min = time.minute.toString().padLeft(2, "0");
    final sec = time.second.toString().padLeft(2, "0");
    return "$hour:$min:$sec";
  }
}
