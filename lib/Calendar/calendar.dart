import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../menu.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

const scheduleViewSettings = ScheduleViewSettings(
  monthHeaderSettings:
      MonthHeaderSettings(backgroundColor: Color.fromARGB(255, 227, 233, 255)),
);

class CalendarState extends State<Calendar> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    _fetchDataAsync();
  }

  Future<void> _fetchDataAsync() async {
    final data = await _getDataSourceAsync();
    setState(() {
      events = data;
    });
  }

  Future<List<Event>> _getDataSourceAsync() async {
    final String url = 'https://localhost:7059/Calendar/all';

    final response = await http.get(Uri.parse(url));

    final List<Event> events = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data is List) {
        for (final eventData in data) {
          final eventName = eventData['title'];
          final startDateTime = DateTime.parse(eventData['starDateTime']);
          final endDateTime = DateTime.parse(eventData['endDateTime']);
          final isAllDay = endDateTime.isBefore(startDateTime);
          final event = Event(
            eventName,
            startDateTime,
            endDateTime,
            Colors.blue, // Vervang dit door de juiste achtergrondkleur
            isAllDay,
          );
          events.add(event);
        }
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: SfCalendar(
        view: MediaQuery.of(context).size.width > 768
            ? CalendarView.week
            : CalendarView.schedule,
        monthViewSettings: MonthViewSettings(showAgenda: true),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeFormat: 'HH:mm',
        ),
        dataSource: EventDataSource(events),
        scheduleViewSettings: scheduleViewSettings,
        selectionDecoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          shape: BoxShape.rectangle,
        ),
        todayHighlightColor: Colors.blue,
        showNavigationArrow: true,
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
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

class Event {
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
