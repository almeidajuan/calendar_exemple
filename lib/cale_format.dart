import 'package:table_calendar/table_calendar.dart';

enum CaleFormat {
  week(CalendarFormat.week),
  month(CalendarFormat.month);

  const CaleFormat(this.format);

  final CalendarFormat format;
}
