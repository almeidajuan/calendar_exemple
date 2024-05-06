// Generated by Dart Safe Data Class Generator. * Change this header on extension settings *
// ignore_for_file: type=lint
import 'package:calendar_exemple/calendar_store.dart';
import 'package:calendar_exemple/event.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final today = DateTime.now().toUtc();

  late var startOfWeek = today.subtract(Duration(days: today.weekday));
  late var endOfWeek = startOfWeek.add(Duration(days: 6));

  void setWeek(DateTime date) {
    startOfWeek = date;
    endOfWeek = startOfWeek.add(Duration(days: 6));

    setState(() {});
  }

  void setAppointmentsOfWeek(DateTime firstDay) {}

  @override
  Widget build(BuildContext context) {
    final format = context.watch<CalendarStore>().calendar.format;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Calendar Pose'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 24, left: 32, right: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color(0xFF5184E4).withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar(
              focusedDay: startOfWeek,
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2025, 10, 16),
              daysOfWeekVisible: false,
              locale: 'pt_BR',
              calendarBuilders: CalendarBuilders(
                prioritizedBuilder: (_, day, __) {
                  return switch (format) {
                    CalendarFormat.week => WeekDay(date: day),
                    CalendarFormat.month => MonthDay(date: day),
                    _ => null,
                  };
                },
                // * Customized the day
                defaultBuilder: (_, day, focused) => SuperHero(
                  maxHeigth: 600,
                  maxWidth: 600,
                  child: switch (format) {
                    CalendarFormat.week => WeekDay(date: day),
                    CalendarFormat.month => MonthDay(date: day),
                    _ => SizedBox.shrink(),
                  },
                ),
                outsideBuilder: (context, day, focusedDay) {
                  return GestureDetector(
                    onTap: () {},
                    child: switch (format) {
                      CalendarFormat.week => WeekDay(date: day),
                      CalendarFormat.month =>
                        MonthDay(date: day, disable: true),
                      _ => null,
                    },
                  );
                },
              ),
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPageChanged: (focusedDay) {
                setWeek(focusedDay);
              },
              rowHeight: 64,
              calendarFormat: format,
            ),
            Expanded(
              child: EventTable(
                startOfWeek: DateTime(2024, 4, 28),
                timeUnit: 30.minutes,
                cellBuilder: (cell) {
                  return MyEventCell(
                    date: cell.date,
                  )
                      .animate(delay: 100.ms * cell.j)
                      .scaleXY(begin: 1.1)
                      .fadeIn();
                },
                eventBuilder: (index, event) {
                  return MyEventCard(
                    event: event,
                  ).animate(delay: 600.ms * index).scaleXY(begin: 1.1).fadeIn();
                },
                events: context.watch<CalendarStore>().clinicalAppointments,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventTable extends StatelessWidget {
  const EventTable({
    super.key,
    required this.startOfWeek,
    required this.timeUnit,
    required this.events,
    this.startTime = const TimeOfDay(hour: 8, minute: 0),
    this.endTime = const TimeOfDay(hour: 18, minute: 0),
    this.cellHeight = 18.0,
    required this.cellBuilder,
    required this.eventBuilder,
  });
  final DateTime startOfWeek;
  final Duration timeUnit;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double cellHeight;
  final List<Event> events;
  final Widget Function(Cell cell) cellBuilder;
  final Widget Function(int index, Event event) eventBuilder;

  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;
    Animate.defaultDuration = 1200.ms;
    Animate.defaultCurve = Curves.fastOutSlowIn;

    double topDistance(DateTime startAt) {
      final difference = startAt.inMinutes - startTime.inMinutes;
      return difference / timeUnit.inMinutes;
    }

    int leftDistance(DateTime startAt) {
      // we ignore the time of the day
      return startAt.date.difference(startOfWeek.date).inDays;
    }

    Cell cellOf(int iDay, int jCell) {
      final minutes = startTime.inMinutes + (timeUnit.inMinutes * jCell);
      final date = startOfWeek.add(Duration(days: iDay, minutes: minutes));

      return Cell(iDay, jCell, date);
    }

    final cellRatio = 60 / timeUnit.inMinutes;
    final cellCount = (endTime.hour - startTime.hour) * cellRatio;

    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth / 7;
        final height = cellRatio * cellHeight;

        return Container(
          height: cellCount * height,
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var iDay = 0; iDay < 7; iDay++)
                    Column(
                      children: [
                        for (var jCell = 0; jCell < cellCount; jCell++)
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
        );
      }),
    );
  }
}

class MyEventCell extends StatelessWidget {
  const MyEventCell({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return SuperHero(
      maxHeigth: 600,
      maxWidth: 400,
      child: LayoutBuilder(builder: (context, constraints) {
        final isOpen = constraints.maxHeight > 200;

        return Container(
          margin: const EdgeInsets.only(right: 4, bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1.2,
              color: Color(0xFF5184E4).withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TimeOfDay.fromDateTime(date).format(context),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              if (isOpen)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(date.toString()),
                    TextFormField(),
                    TextFormField(),
                    TextFormField(),
                    TextFormField(),
                    TextFormField(),
                  ],
                ),
            ],
          ),
        );
      }),
    );
  }
}

class MyEventCard extends StatelessWidget {
  const MyEventCard({
    super.key,
    required this.event,
  });
  final Event event;

  @override
  Widget build(BuildContext context) {
    return SuperHero(
      maxHeigth: 600,
      maxWidth: 400,
      child: LayoutBuilder(builder: (context, constraints) {
        final isOpen = constraints.maxHeight > 200;

        return Container(
          margin: const EdgeInsets.only(right: 4, bottom: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Color(0xFFFF6213).withOpacity(0.1),
              border: Border.all(
                width: 1.2,
                color: Color(0xFF5184E4).withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  width: 2,
                  margin: EdgeInsets.symmetric(vertical: 2),
                  height: constraints.maxHeight * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${event.title}\n'
                        '${event.inMinutes} minutos',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      if (isOpen)
                        Column(
                          children: [
                            TextFormField(),
                            TextFormField(),
                            TextFormField(),
                            TextFormField(),
                            TextFormField(),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class AnimatedHover extends StatefulWidget {
  const AnimatedHover({super.key, required this.child});
  final Widget child;

  @override
  State<AnimatedHover> createState() => _AnimatedHoverState();
}

class _AnimatedHoverState extends State<AnimatedHover> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedScale(
        duration: 300.ms,
        scale: isHovering ? 1.1 : 1.0,
        child: widget.child,
      ),
    );
  }
}

class SuperHero extends StatelessWidget {
  const SuperHero({
    super.key,
    this.duration = const Duration(milliseconds: 600),
    this.barrierColor = Colors.black54,
    this.maxHeigth,
    this.maxWidth,
    this.rootNavigator = true,
    this.barrierDismissible = true,
    this.replacement,
    required this.child,
  });
  final Duration duration;
  final Color barrierColor;
  final double? maxHeigth;
  final double? maxWidth;
  final bool rootNavigator;
  final bool barrierDismissible;
  final Widget? replacement;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: rootNavigator).push(
          PageRouteBuilder(
            opaque: false,
            barrierColor: barrierColor,
            barrierDismissible: barrierDismissible,
            transitionDuration: duration,
            pageBuilder: (context, _, __) {
              return Center(
                child: SizedBox(
                  height: maxHeigth,
                  width: maxWidth,
                  child: Hero(
                    tag: hashCode,
                    child: Material(
                      type: MaterialType.transparency,
                      child: replacement ?? child,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      child: AnimatedHover(
        child: Hero(
          tag: hashCode,
          child: Material(
            type: MaterialType.transparency,
            child: child,
          ),
        ),
      ),
    );
  }
}

extension DateTimeX on DateTime {
  int get inMinutes => hour * 60 + minute;
}

extension TimeOfDayX on TimeOfDay {
  int get inMinutes => hour * 60 + minute;
}

class Cell {
  Cell(this.i, this.j, this.date);

  /// Day of the week (0-6).
  final int i;

  /// Cell of the day (0-N). Depends on the time unit.
  final int j;

  /// The date of the cell. (Start time)
  final DateTime date;
}

class SelectWeek extends StatelessWidget {
  const SelectWeek({
    super.key,
    required this.startOfWeek,
    required this.weekDays,
    required this.months,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  final DateTime startOfWeek;
  final List<String> weekDays;
  final List<String> months;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.outlined(
          onPressed: onPreviousWeek,
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          style: ButtonStyle(
            side: MaterialStatePropertyAll(
              BorderSide(color: Colors.grey.shade300),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        //

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${startOfWeek.day.toString().padLeft(2, '0')} '
            '${months[startOfWeek.month - 1].substring(0, 3)}, '
            '${startOfWeek.year} - '
            '${startOfWeek.add(const Duration(days: 6)).day.toString().padLeft(2, '0')} '
            '${months[startOfWeek.add(const Duration(days: 6)).month - 1].substring(0, 3)} '
            '${startOfWeek.year}',
          ),
        ),

        //
        IconButton.outlined(
          onPressed: onNextWeek,
          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          style: ButtonStyle(
            side: MaterialStatePropertyAll(
              BorderSide(color: Colors.grey.shade300),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WeekDay extends StatelessWidget {
  const WeekDay({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dayOfWeek = DateFormat.EEEE('pt_BR').format(date).split('-')[0];
    final dayOfMonth = date.day.toString().padLeft(2, '0');

    final today = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color:
            isSameDay(today, date) ? Color(0xFF5184E4).withOpacity(0.2) : null,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            dayOfWeek,
            style: TextStyle(
              color:
                  isSameDay(today, date) ? Color(0xFF5184E4) : Colors.black54,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            dayOfMonth,
            style: TextStyle(
              color: isSameDay(today, date) ? Color(0xFF5184E4) : null,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MonthDay extends StatelessWidget {
  const MonthDay({
    super.key,
    required this.date,
    this.disable = false,
  });

  final DateTime date;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    final dayOfMonth = date.day.toString().padLeft(2, '0');
    final today = DateTime.now();

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: (isSameDay(today, date))
            ? const Color(0xFF5184E4).withOpacity(0.2)
            : null,
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            dayOfMonth,
            style: TextStyle(
              color: isSameDay(today, date)
                  ? const Color(0xFF5184E4)
                  : disable
                      ? Colors.grey
                      : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
