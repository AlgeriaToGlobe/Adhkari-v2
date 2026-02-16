/// Hijri (Islamic) calendar utility using the tabular Islamic calendar algorithm.
///
/// The tabular calendar follows a 30-year cycle where years
/// 2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29 are leap years (355 days).
/// Normal years have 354 days.
/// Odd months have 30 days, even months have 29 days,
/// except month 12 in a leap year which has 30 days.
class HijriDate {
  final int year;
  final int month;
  final int day;

  const HijriDate(this.year, this.month, this.day);

  // ── Hijri month names in Arabic ──
  static const List<String> monthNames = [
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الثاني',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  // ── Arabic day abbreviations (Saturday first) ──
  static const List<String> dayAbbreviations = [
    'سب',
    'أح',
    'إث',
    'ثل',
    'أر',
    'خم',
    'جم',
  ];

  // ── Leap years in the 30-year cycle ──
  static const List<int> _leapYearsInCycle = [
    2, 5, 7, 10, 13, 16, 18, 21, 24, 26, 29,
  ];

  /// The name of this month in Arabic.
  String get monthName => monthNames[month - 1];

  /// Formatted string: "day monthName year"
  String get formatted => '$day $monthName $year';

  /// Whether this Hijri year is a leap year.
  static bool isLeapYear(int year) {
    return _leapYearsInCycle.contains(year % 30);
  }

  /// Number of days in a given Hijri month.
  static int daysInMonth(int year, int month) {
    if (month.isOdd) return 30; // months 1,3,5,7,9,11
    if (month < 12) return 29; // months 2,4,6,8,10
    return isLeapYear(year) ? 30 : 29; // month 12
  }

  /// Convert a Gregorian [DateTime] to [HijriDate].
  ///
  /// Uses the Kuwaiti algorithm (tabular Islamic calendar).
  static HijriDate fromGregorian(DateTime date) {
    final jd = _gregorianToJD(date.year, date.month, date.day);

    int l = jd - 1948440 + 10632;
    int n = (l - 1) ~/ 10631;
    l = l - 10631 * n + 354;
    int j = ((10985 - l) ~/ 5316) * ((50 * l) ~/ 17719) +
        (l ~/ 5670) * ((43 * l) ~/ 15238);
    l = l -
        ((30 - j) ~/ 15) * ((17719 * j) ~/ 50) -
        (j ~/ 16) * ((15238 * j) ~/ 43) +
        29;
    int m = (24 * l) ~/ 709;
    int d = l - (709 * m) ~/ 24;
    int y = 30 * n + j - 30;

    return HijriDate(y, m, d);
  }

  /// Convert a [HijriDate] to Gregorian [DateTime].
  static DateTime toGregorian(int hYear, int hMonth, int hDay) {
    final jd = _hijriToJD(hYear, hMonth, hDay);
    return _jdToGregorian(jd);
  }

  /// Get the weekday (1=Monday … 7=Sunday) of a Hijri date.
  int get weekday {
    final greg = toGregorian(year, month, day);
    return greg.weekday;
  }

  /// Get the weekday index for the calendar grid (0=Saturday … 6=Friday).
  int get calendarColumn {
    final wd = weekday; // 1=Mon … 7=Sun
    // Map: Sat=0, Sun=1, Mon=2, Tue=3, Wed=4, Thu=5, Fri=6
    return wd == 7 ? 1 : wd == 6 ? 0 : wd + 1;
  }

  /// The column index (0=Saturday … 6=Friday) of the first day of a Hijri month.
  static int firstDayColumn(int year, int month) {
    final firstDay = HijriDate(year, month, 1);
    return firstDay.calendarColumn;
  }

  /// Check if this date is today.
  bool get isToday {
    final today = HijriDate.fromGregorian(DateTime.now());
    return year == today.year && month == today.month && day == today.day;
  }

  // ── Private helpers ──

  /// Gregorian date to Julian Day Number.
  static int _gregorianToJD(int year, int month, int day) {
    if (month <= 2) {
      year--;
      month += 12;
    }
    int a = year ~/ 100;
    int b = 2 - a + a ~/ 4;
    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day +
        b -
        1524;
  }

  /// Hijri date to Julian Day Number.
  static int _hijriToJD(int year, int month, int day) {
    return ((11 * year + 3) ~/ 30) +
        354 * year +
        30 * month -
        ((month - 1) ~/ 2) +
        day +
        1948440 -
        385;
  }

  /// Julian Day Number to Gregorian [DateTime].
  static DateTime _jdToGregorian(int jd) {
    int l = jd + 68569;
    int n = (4 * l) ~/ 146097;
    l = l - (146097 * n + 3) ~/ 4;
    int i = (4000 * (l + 1)) ~/ 1461001;
    l = l - (1461 * i) ~/ 4 + 31;
    int j = (80 * l) ~/ 2447;
    int day = l - (2447 * j) ~/ 80;
    l = j ~/ 11;
    int month = j + 2 - 12 * l;
    int year = 100 * (n - 49) + i + l;
    return DateTime(year, month, day);
  }
}
