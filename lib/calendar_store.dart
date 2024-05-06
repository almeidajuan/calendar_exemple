import 'package:flutter/material.dart';

class CalendarStore extends ChangeNotifier {
  late DateTime _startOfWeek;
  late DateTime _endOfWeek;

  DateTime get startOfWeek => _startOfWeek;
  DateTime get endOfWeek => _endOfWeek;

  void init() {
    final now = DateTime.now().toUtc();
    _startOfWeek = now.subtract(Duration(days: now.weekday));
    _endOfWeek = startOfWeek.add(const Duration(days: 6));
  }

  void setDate(DateTime value) {
    _startOfWeek = value.subtract(Duration(days: value.weekday));
    _endOfWeek = startOfWeek.add(const Duration(days: 6));
    notifyListeners();
  }
}
