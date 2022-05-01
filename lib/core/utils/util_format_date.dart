import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class FormatDate {
  static String date1({@required DateTime date}) {
    var formatDate = DateFormat.yMMMMd();
    var formatHour = DateFormat.Hm();
    return "${formatDate.format(date).toString()} @${formatHour.format(date)}";
  }

  static String date2({@required DateTime date}) {
    var formatDate = DateFormat.yMMMMd();
    var formatHour = DateFormat.Hm();
    return "${formatDate.format(date).toString()} @${formatHour.format(date)}";
  }

  static String date3({@required DateTime date}) {
    var formatDate = DateFormat.yMMMMd();
    var formatHour = DateFormat.Hm();
    return "${formatDate.format(date).toString()} @${formatHour.format(date)}";
  }
}
