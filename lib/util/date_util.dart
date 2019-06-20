
DateTime str2Date(String dateStr) {
  if (dateStr == null || dateStr.length != 8) return null;
  try {
    int year = int.parse(dateStr.substring(0, 4));
    int month = int.parse(dateStr.substring(4, 6));
    int day = int.parse(dateStr.substring(6));
    return DateTime(year, month, day);
  } catch (e) {
    return null;
  }
}
// Format date as "yyyymmdddd"
String formatDate(DateTime date) {
  if (date == null) date = DateTime.now();
  return "${date.year}${twoDigits(date.month)}${twoDigits(date.day)}";
}

String twoDigits(int n) {
  if (n >= 10) return "${n}";
  return "0${n}";
}