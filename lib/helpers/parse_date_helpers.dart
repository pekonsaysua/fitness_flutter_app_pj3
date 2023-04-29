class ParseDate {
  static int getDay(String dateTime) {
    var dur = DateTime.now().difference(DateTime.parse(dateTime));
    return dur.inDays;
  }
  static int getHour(String dateTime) {
    var dur = DateTime.now().difference(DateTime.parse(dateTime));
    return dur.inHours;
  }
  static int getMinute(String dateTime) {
    var dur = DateTime.now().difference(DateTime.parse(dateTime));
    return dur.inMinutes;
  }
}
