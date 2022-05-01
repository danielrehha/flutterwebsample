import '../enum_date_range_type.dart';

String mapDateRangeToText(DateRangeType range) {
  if (range == DateRangeType.Past7Days) {
    return "Elmúlt 7 nap";
  }
  if (range == DateRangeType.Past30Days) {
    return "Elmúlt 30 nap";
  }
  if (range == DateRangeType.PastYear) {
    return "Elmúlt 1 év";
  }
  return "Egyéni";
}

List<DateTime> mapDateRangeToDateTimeList(DateRangeType range) {
  List<DateTime> result = [];

  final now = DateTime.now();
  final nowDefault = DateTime(now.year, now.month, now.day);
  if (range == DateRangeType.Past7Days) {
    result.add(nowDefault.subtract(Duration(days: 7)));
  }
  if (range == DateRangeType.Past30Days) {
    result.add(nowDefault.subtract(Duration(days: 30)));
  }
  if (range == DateRangeType.PastYear) {
    result.add(nowDefault.subtract(Duration(days: 365)));
  }

  result.add(nowDefault);

  return result;
}
