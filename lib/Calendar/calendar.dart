import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../menu.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}
const scheduleViewSettings = ScheduleViewSettings(
  monthHeaderSettings: MonthHeaderSettings(
    backgroundColor: Color.fromARGB(255, 227, 233, 255)
  ),
);

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Menu(
      child: SfCalendar(
        view: CalendarView.schedule,
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeFormat: 'HH:mm',
        ),
        dataSource: MeetingDataSource(_getDataSource()),
        scheduleViewSettings: scheduleViewSettings,

      ),
    );
  }

  List<Meeting> _getDataSource() {
    // sample data
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting('Voorbeeld 1', startTime, endTime, const Color.fromARGB(255, 102, 140, 217), false));
    meetings.add(Meeting('Voorbeeld 2', startTime.add(const Duration(hours: 2)), endTime.add(const Duration(hours: 2)), const Color.fromARGB(255, 102, 140, 217), false));
    meetings.add(Meeting('Voorbeeld 3', startTime.add(const Duration(hours: 24)), endTime.add(const Duration(hours: 24)), const Color.fromARGB(255, 250, 209, 99), false));

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
