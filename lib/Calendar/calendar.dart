import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
  String? _subjectText, _startTimeText, _endTimeText, _dateText, _timeDetails;
  final CalendarController _controller = CalendarController();

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
            : CalendarView.day,
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
        onTap: calendarTapped,
        cellEndPadding: 40,
        allowedViews: [
          CalendarView.day,
          CalendarView.week,
          CalendarView.month,
          CalendarView.schedule,
        ],
        monthViewSettings: MonthViewSettings(
            navigationDirection: MonthNavigationDirection.vertical),
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (_controller.view == CalendarView.month &&
        details.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        details.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
    if (details.targetElement == CalendarElement.appointment ||
        details.targetElement == CalendarElement.agenda) {
      final Event appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.eventName;
      _dateText = DateFormat('MMMM dd, yyyy')
          .format(appointmentDetails.from)
          .toString();
      _startTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.from).toString();
      _endTimeText =
          DateFormat('hh:mm a').format(appointmentDetails.to).toString();
      _timeDetails = '$_startTimeText - $_endTimeText';
    } else if (details.targetElement == CalendarElement.calendarCell) {
      // TODO add a new event in this modal
      _subjectText = "Add event";
      _dateText = DateFormat('MMMM dd, yyyy').format(details.date!).toString();
      _timeDetails = '';
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(child: new Text('$_subjectText')),
            content: Container(
              height: 80,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '$_dateText',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Text(_timeDetails!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: new Text('Sluiten'))
            ],
          );
        });
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
