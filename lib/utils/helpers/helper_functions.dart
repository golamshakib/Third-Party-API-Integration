import '../texts/text_strings.dart';
import 'package:intl/intl.dart';

String iconUrl(String icon) => '$iconPrefix$icon$iconSuffix' ;

String getFormatedDateTime(num dt, {String pattern = 'dd/MM/yyyy'}) {
  return DateFormat(pattern).format(
    DateTime.fromMillisecondsSinceEpoch(dt.toInt() * 1000),
  );
}

bool isToday(String weekdayName){
  return DateFormat('EEEE').format(DateTime.now()) == weekdayName;
}

bool isTomorrow(String weekdayName){
  return DateFormat('EEEE').format(DateTime.now().add(const Duration(days: 1))) == weekdayName;
}

String getFormatedDay(num dt){

  final weekDay = DateFormat('EEEE').format(
      DateTime.fromMillisecondsSinceEpoch(dt.toInt() *1000));

  if (isToday(weekDay)){
    return 'Today';
  }
  if (isTomorrow(weekDay)){
    return 'Tomorrow';
  }
  return weekDay;
}
