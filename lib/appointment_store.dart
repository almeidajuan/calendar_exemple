import 'package:calendar_exemple/cale_format.dart';
import 'package:calendar_exemple/appointment.dart';
import 'package:flutter/material.dart';

class AppointmentStore extends ChangeNotifier {
  CaleFormat _calendar = CaleFormat.week;

  CaleFormat get calendar => _calendar;

  final List<Appointment> _appointments = [
    Appointment(
      title: 'Event 01',
      startAt: DateTime.utc(2024, 04, 28, 08, 00),
      endAt: DateTime.utc(2024, 04, 28, 09, 00),
    ),
    Appointment(
      title: 'Event 02',
      startAt: DateTime.utc(2024, 04, 30, 09, 00),
      endAt: DateTime.utc(2024, 04, 30, 09, 30),
    ),
    Appointment(
      title: 'Event 03',
      startAt: DateTime.utc(2024, 05, 01, 10, 00),
      endAt: DateTime.utc(2024, 05, 01, 11, 45),
    ),
    Appointment(
      title: 'Event 03',
      startAt: DateTime.utc(2024, 05, 07, 10, 00),
      endAt: DateTime.utc(2024, 05, 07, 10, 55),
    ),
  ];

  List<Appointment> get clinicalAppointments => _appointments;

  Future<void> addAppointments(Appointment event) async {
    _appointments.add(event);
    notifyListeners();
  }

  void setCalendar(CaleFormat calendar) {
    _calendar = calendar;
    notifyListeners();
  }
}
