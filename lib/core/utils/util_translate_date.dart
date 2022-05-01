import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class TranslateDate {
  String call({@required DateTime date}) {
    var formatDate = DateFormat.yMMMMd('HU_hu');
    final now = DateTime.now();
   /*  if (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day) {
      return 'Ma (${date.month}.${date.day})';
    } else if (now.year == date.year &&
        now.month == date.month &&
        now.day + 1 == date.day) {
      return 'Holnap (${date.month}.${date.day})';
    } else { */
      return formatDate.format(date).toString();
    /* } */
  }

  String numeric(DateTime date) {
    if (date.day < 10) {
      return "${date.year}.${date.month}.0${date.day}";
    }
    return "${date.year}.${date.month}.${date.day}";
  }
}
