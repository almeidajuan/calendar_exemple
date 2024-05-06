import 'package:calendar_exemple/cale_format.dart';
import 'package:calendar_exemple/event.dart';
import 'package:flutter/material.dart';

class CalendarStore extends ChangeNotifier {
  CaleFormat _calendar = CaleFormat.week;

  CaleFormat get calendar => _calendar;

  final List<Event> _clinicalAppointments = [
    Event(
      title: 'Event 01',
      startAt: DateTime.utc(2024, 04, 28, 08, 00),
      endAt: DateTime.utc(2024, 04, 28, 09, 00),
    ),
    Event(
      title: 'Event 02',
      startAt: DateTime.utc(2024, 04, 30, 09, 00),
      endAt: DateTime.utc(2024, 04, 30, 09, 30),
    ),
    Event(
      title: 'Event 03',
      startAt: DateTime.utc(2024, 05, 01, 10, 00),
      endAt: DateTime.utc(2024, 05, 01, 11, 45),
    ),
    Event(
      title: 'Event 03',
      startAt: DateTime.utc(2024, 05, 02, 10, 00),
      endAt: DateTime.utc(2024, 05, 02, 10, 45),
    ),
  ];

  List<Event> get clinicalAppointments => _clinicalAppointments;

  void setCalendar(CaleFormat calendar) {
    _calendar = calendar;
    notifyListeners();
  }
}
