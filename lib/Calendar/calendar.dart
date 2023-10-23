import 'dart:convert';
import 'dart:io';

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
    final client = HttpClient();
    final List<Event> events = [];
    print("helllloooo");
    try {
      final request = await client
          .getUrl(Uri.parse('https://localhost:7059/Calendar/stam'));
      final response = await request.close();
      print("kippp");

      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);

        if (data is List) {
          for (final eventData in data) {
            print(eventData['title']);
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
        } else {
          print('Ongeldige JSON-response.');
        }
      } else {
        print('Fout bij het ophalen van gegevens: ${response.statusCode}');
      }
    } catch (exception) {
      print('Er is een fout opgetreden: $exception');
    } finally {
      client.close();
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: SfCalendar(
        view: CalendarView.schedule,
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeFormat: 'HH:mm',
        ),
        dataSource: EventDataSource(events),
        scheduleViewSettings: scheduleViewSettings,
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
