import 'package:calendar_exemple/appointment.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

import 'calendar_page.dart';

class EventMonthlyTable extends StatelessWidget {
  const EventMonthlyTable({
    super.key,
    required this.startOfWeek,
    required this.timeUnit,
    required this.events,
    this.startTime = const TimeOfDay(hour: 8, minute: 0),
    this.endTime = const TimeOfDay(hour: 18, minute: 0),
    this.cellHeight = 48.0,
    required this.cellBuilder,
    required this.eventBuilder,
  });
  final DateTime startOfWeek;
  final Duration timeUnit;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double cellHeight;
  final List<Appointment> events;
  final Widget Function(Cell cell) cellBuilder;
  final Widget Function(int index, Appointment event) eventBuilder;

  @override
  Widget build(BuildContext context) {
    double topDistance(DateTime startAt) {
      final difference = startAt.inMinutes - startTime.inMinutes;
      return difference / timeUnit.inMinutes;
    }

    int leftDistance(DateTime startAt) {
      // we ignore the time of the day
      return startAt.date.difference(startOfWeek.date).inDays;
    }

    Cell cellOf(int iDay, int jCell) {
      // final minutes = startTime.inMinutes + (timeUnit.inMinutes * jCell);
      final date = startOfWeek.add(Duration(days: iDay + jCell));

      return Cell(iDay, jCell, date);
    }

    final cellRatio = 60 / timeUnit.inMinutes;
    final cellCount = (endTime.hour - startTime.hour) * cellRatio;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth / 7;
        final height = cellRatio * cellHeight;

        return SingleChildScrollView(
          child: SizedBox(
            height: cellCount * height,
            child: Stack(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var iDay = 0; iDay < 7; iDay++)
                      Column(
                        children: [
                          for (var jCell = 0; jCell < 5; jCell++)
                            SizedBox(
                              height: height,
                              width: width,
                              child: cellBuilder(cellOf(iDay, jCell)),
                            ),
                        ],
                      ),
                  ],
                ),
                for (final (index, event) in events.indexed)
                  Positioned(
                    top: topDistance(event.startAt) * height,
                    left: leftDistance(event.startAt) * width,
                    height: (event.inMinutes / timeUnit.inMinutes) * height,
                    width: width,
                    child: eventBuilder(index, event),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
