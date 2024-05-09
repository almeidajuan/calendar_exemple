// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

/// Example event class.
class Appointment {
  final String title;
  final DateTime startAt;
  final DateTime endAt;

  const Appointment({
    this.title = '',
    required this.startAt,
    required this.endAt,
  });

  @override
  String toString() => title;

  Duration get duration => endAt.difference(startAt);
  int get inMinutes => duration.inMinutes;
  int get eventSize => inMinutes ~/ 15;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
// final kEvents = LinkedHashMap<DateTime, List<AtendimentoModel>>(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(_kEventSource);

// final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
//     key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
//     value: (item) => List.generate(item % 4 + 1,
//         (index) => AtendimentoModel('Event $item | ${index + 1}')))
//   ..addAll({
//     kToday: [
//       AtendimentoModel('Today\'s Event 1'),
//       AtendimentoModel('Today\'s Event 2'),
//     ],
//   });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
