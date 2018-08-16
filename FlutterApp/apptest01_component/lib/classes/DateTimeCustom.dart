/// Extension of the DateTime class with an extra [specialCheck] boolean.
///
/// See [specialCheck] for detail on what this variable does.
class DateTimeCustom extends DateTime {
  DateTimeCustom(
      {int year,
      int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      bool specialCheck})
      : specialCheck = specialCheck ?? false,
        super(year, month, day, hour, minute, second, 0, 0);

  /// Toggles the status of the 'special' flag.
  ///
  /// This flag is to determine whether a particular instance of this DateTime
  /// is 'special'. For example, the 'Install Date' instance uses this flag to
  /// represent a value of 'Since Beginning' which effectively means since
  /// time=0. Then the 'Removal Date' instance uses this flag to define whether
  /// a component is currently installed or not.
  bool specialCheck;

  static DateTimeCustom now() {
    DateTime curNow = new DateTime.now();
    return new DateTimeCustom(
        year: curNow.year,
        month: curNow.month,
        day: curNow.day,
        hour: curNow.hour,
        minute: curNow.minute,
        second: curNow.second);
  }
}
