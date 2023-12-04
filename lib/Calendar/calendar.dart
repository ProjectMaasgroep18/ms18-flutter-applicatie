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
  monthHeaderSettings: MonthHeaderSettings(backgroundColor: Color.fromARGB(255, 227, 233, 255)),
);

class CalendarState extends State<Calendar> {
  String? _subjectText, _startTimeText, _endTimeText, _dateText, _timeDetails;
  final CalendarController _controller = CalendarController();
  String source = 'https://localhost:7059/Calendar/all';
  String lastSource = '';
  List<Event> events = [];
  List<String> list = <String>['Alle groepen', 'Welpen', 'Matrozen', 'Zee verkenners', 'Stam', 'Global'];
  String _dropdownValue = "Alle groepen";

  Future<void> _fetchDataAsync(String source) async {
    if (source != lastSource) {
      var data = await _getDataSourceAsync(source);
      setState(() {
        lastSource = source;
        events = data;
      });
    }
  }

  Future<List<Event>> _getDataSourceAsync(String source) async {
    String url = source;
    debugPrint("custom prints, source loaded:" + source);
    var response = await http.get(Uri.parse(url));
    final List<Event> events = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      debugPrint("" + data);

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
    _fetchDataAsync(source);
    return Menu(
      child: Stack(
        children: [
          SfCalendar(
            view: MediaQuery.of(context).size.width > 768 ? CalendarView.week : CalendarView.day,
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
            monthViewSettings: MonthViewSettings(navigationDirection: MonthNavigationDirection.vertical),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                value: _dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  source = value!;
                  setState(() {
                    _dropdownValue = value;
                    switch (list.indexOf(value)) {
                      case 0:
                        source = 'https://localhost:7059/Calendar/all';
                        break;
                      case 1:
                        source = 'https://localhost:7059/Calendar/welpen';
                        break;
                      case 2:
                        source = 'https://localhost:7059/Calendar/matrozen';
                        break;
                      case 3:
                        source = 'https://localhost:7059/Calendar/zeeVerkenners';
                        break;
                      case 4:
                        source = 'https://localhost:7059/Calendar/stam';
                        break;
                      case 5:
                        source = 'https://localhost:7059/Calendar/global';
                        break;
                    }
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void calendarTapped(CalendarTapDetails details) {
    if (_controller.view == CalendarView.month && details.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week || _controller.view == CalendarView.workWeek) && details.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
    if (details.targetElement == CalendarElement.appointment || details.targetElement == CalendarElement.agenda) {
      final Event appointmentDetails = details.appointments![0];
      _subjectText = appointmentDetails.eventName;
      _dateText = DateFormat('MMMM dd, yyyy').format(appointmentDetails.from).toString();
      _startTimeText = DateFormat('HH:mm').format(appointmentDetails.from).toString();
      _endTimeText = DateFormat('HH:mm').format(appointmentDetails.to).toString();
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
                        Text(_timeDetails!, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
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
