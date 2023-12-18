import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/date_time_patterns.dart';
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
  String? _eventId,
      _subjectText,
      _startTimeText,
      _endTimeText,
      _startDateText,
      _endDateText,
      _timeDetails,
      _description,
      _location;
  int? _calendarId;
  final CalendarController _controller = CalendarController();
  TextEditingController startdateinput = TextEditingController();
  TextEditingController enddateinput = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  bool isNewEvent = false;
  bool shouldShowForm = false;
  final restfulUrl = 'https://localhost:7059/Calendar/Event';

  Future<void> sendDeleteRequest(calendarName, id) async {
    var response = await http.delete(
        Uri.parse(restfulUrl).replace(queryParameters: {
          'calendarName': calendarName,
          'id': id,
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event verwijderd')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event is niet verwijderd, probeer opnieuw')),
      );
    }
    _fetchDataAsync();
  }

  Future<void> sendEditRequest(
      calendarName,
      String? id,
      String startTime,
      String endTime,
      String? title,
      String? description,
      String? location,
      String startDate,
      String endDate,
      contextForm) async {
    var formattedFromStr =
        DateTime.parse(startDate + " " + startTime).toIso8601String();
    var formattedToStr =
        DateTime.parse(endDate + " " + endTime).toIso8601String();

    var response = await http.patch(
        Uri.parse(restfulUrl).replace(queryParameters: {
          'calendarName': calendarName,
          'StarDateTime': formattedFromStr,
          'EndDateTime': formattedToStr,
          'Title': title,
          'Description': description,
          'id': id,
          'Location': location,
          'CalendarId': calendarName
        }),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event aangepast')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event is niet aangepast, probeer opnieuw')),
      );
      return;
    }
    await _fetchDataAsync();
    Navigator.of(contextForm).pop();
  }

  Future<void> sendCreateRequest(calendarName, id, startTime, endTime, title,
      description, location, endDate, startDate, context) async {
    // var time = endDate + endTime;
    var tedail = description;
    // var response = await http.post(
    //     Uri.parse(restfulUrl).replace(queryParameters: {
    //       'calendarName': calendarName,
    //       'StarDateTime': "2023-12-11T07:15:00+01:00",
    //       'EndDateTime': "2023-12-11T09:45:00+01:00",
    //       'Title': title,
    //       'Description': description,
    //       'id': id,
    //       'Location': location,
    //       'CalendarId': calendarName
    //     }),
    //     headers: {"Content-Type": "application/json"});

    // if (response.statusCode == 200) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Event aangemaakt')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Event is niet aangemaakt, probeer opnieuw')),
    //   );
    // }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    startdateinput.text = "";
    enddateinput.text = "";
    startTime.text = "";
    endTime.text = "";
    isNewEvent = false; // Whether form is creating or updating event.
    _description = "";
    _location = "";
    shouldShowForm = false;
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
          final eventId = eventData['id'];
          final calendarId = eventData['calendarId'];
          final eventName = eventData['title'];
          final description = (eventData['description'] == null)
              ? ""
              : eventData['description'];
          final location =
              (eventData['location'] == null) ? "" : eventData['location'];
          final startDateTime = DateTime.parse(eventData['starDateTime']);
          final endDateTime = DateTime.parse(eventData['endDateTime']);
          final isAllDay = endDateTime.isBefore(startDateTime);
          final event = Event(
            eventId,
            calendarId,
            eventName,
            description,
            location,
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
        monthViewSettings: const MonthViewSettings(
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

    switch (details.targetElement) {
      case CalendarElement.appointment:
      case CalendarElement.agenda:
        isNewEvent = false;
        final Event appointmentDetails = details.appointments![0];
        _subjectText = appointmentDetails.eventName;
        _eventId = appointmentDetails.eventId;
        _calendarId = appointmentDetails.calendarId;
        _description = appointmentDetails.description;
        _location = appointmentDetails.location;

        _startDateText =
            DateFormat('yyyy-MM-dd').format(appointmentDetails.from).toString();
        _startTimeText =
            DateFormat('HH:mm').format(appointmentDetails.from).toString();
        print(DateFormat('HH:mm:ss').format(appointmentDetails.from));

        _endDateText =
            DateFormat('yyyy-MM-dd').format(appointmentDetails.to).toString();
        _endTimeText = DateFormat('hh:mm').format(appointmentDetails.to);
        _timeDetails = '$_startTimeText - $_endTimeText';

        // Use existing values.
        startTime.text = _startTimeText!;
        endTime.text = _endTimeText!;
        startdateinput.text = _startDateText!;
        enddateinput.text = _endDateText!;

        break;
      case CalendarElement.calendarCell:
        isNewEvent = true;
        // final Event appointmentDetails = details.appointments![0];
        // _eventId = appointmentDetails.eventId;
        // _calendarId = appointmentDetails.calendarId;
        // _description = appointmentDetails.description;
        // _location = appointmentDetails.location;

        shouldShowForm = true;
        _startTimeText = DateFormat('HH:mm').format(details.date!).toString();

        DateTime adjustedDateTime = details.date!.add(const Duration(hours: 1));

        _endTimeText = DateFormat('HH:mm').format(adjustedDateTime);

        _subjectText = "Agenda item toevoegen";

        startdateinput.text =
            DateFormat('yyyy-MM-dd').format(details.date!).toString();
        enddateinput.text =
            DateFormat('yyyy-MM-dd').format(details.date!).toString();

        startTime.text = DateFormat('HH:mm').format(details.date!).toString();
        endTime.text = DateFormat('HH:mm').format(adjustedDateTime);
        _timeDetails = "";
        TimeOfDay? pickedStartTime2 = null;
        break;
      default:
        break;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$_subjectText'),
            content: SizedBox(
              height: 500,
              child: Column(
                children: <Widget>[
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary if updating existing.
                        if (!isNewEvent) ...[
                          Text(
                            _startDateText!,
                          ),
                          Text(
                            _timeDetails!,
                          ),
                        ],

                        // Create / update event form.
                        TextFormField(
                            controller: startdateinput,
                            decoration: const InputDecoration(
                                labelText: "Vul startdatum in"),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  locale: const Locale('nl', 'NL'),
                                  context: context,
                                  initialDate: isNewEvent
                                      ? DateTime.now()
                                      : DateTime.parse(_startDateText!),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                String formattedDate = DateFormat('yyyy-MM-dd')
                                    .format(pickedDate)
                                    .toString();
                                setState(() {
                                  startdateinput.text = formattedDate;
                                });
                              }
                            },
                            onChanged: (String? newValue) {
                              _startDateText = newValue;
                            }),
                        TextFormField(
                            controller: enddateinput,
                            decoration: const InputDecoration(
                                labelText: "Vul einddatum in"),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  locale: const Locale('nl', 'NL'),
                                  context: context,
                                  initialDate: isNewEvent
                                      ? DateTime.now()
                                      : DateTime.parse(_endDateText!),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                String formattedEndDate =
                                    DateFormat('yyyy-MM-dd')
                                        .format(pickedDate)
                                        .toString();
                                setState(() {
                                  enddateinput.text = formattedEndDate;
                                });
                              }
                            },
                            onChanged: (String? newValue) {
                              _endDateText = newValue;
                            }),
                        TextFormField(
                          controller: startTime,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.access_time),
                              labelText: "Start tijd"),
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedStartTime = await showTimePicker(
                              context: context,
                              initialTime: _startTimeText == ""
                                  ? TimeOfDay.now()
                                  : TimeOfDay(
                                      hour: int.parse(
                                          _startTimeText!.split(":")[0]),
                                      minute: int.parse(_startTimeText!
                                          .split(":")[1]
                                          .split(" ")[0])),
                            );
                            if (pickedStartTime != null) {
                              setState(() {
                                startTime.text = pickedStartTime.toString();
                              });
                            }
                          },
                        ),

                        TextFormField(
                          controller: endTime,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.access_time),
                              labelText: "Eind tijd"),
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedEndTime = await showTimePicker(
                              context: context,
                              initialTime: _endTimeText == ""
                                  ? TimeOfDay.now()
                                  : TimeOfDay(
                                      hour: int.parse(
                                          _endTimeText!.split(":")[0]),
                                      minute: int.parse(_endTimeText!
                                          .split(":")[1]
                                          .split(" ")[0])),
                            );
                            if (pickedEndTime != null) {
                              setState(() {
                                endTime.text = pickedEndTime.toString();
                              });
                            }
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Titel',
                          ),
                          initialValue: isNewEvent ? "" : _subjectText,
                          onChanged: (String? value) {
                            _subjectText = value;
                          },
                        ),
                        TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Locatie',
                            ),
                            initialValue: isNewEvent ? "" : _location,
                            onChanged: (String? value) {
                              _location = value;
                            }),
                        TextFormField(
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: 'Beschrijving',
                            ),
                            initialValue: isNewEvent ? "" : _description,
                            onChanged: (String? value) {
                              _description = value;
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sluiten')),
              if (isNewEvent) ...[
                // Create new event.
                ElevatedButton(
                  onPressed: () {
                    print(_endDateText);
                    print(_startDateText);

                    print(enddateinput.text);
                    print(startdateinput.text);

                    print(endTime.text);
                    print(startTime.text);

                    // sendCreateRequest(
                    // _calendarId.toString(),
                    // _eventId,
                    // _startTimeText,
                    // _endTimeText,
                    // _subjectText,
                    // _description,
                    // _location,
                    // _endDateText,
                    // _startDateText,
                    // context);
                    // Navigator.of(context).pop();

                    // TODO: Add actual submission to back-end.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event toegevoegd')),
                    );
                  },
                  child: const Text('Toevoegen'),
                ),
              ] else ...[
                // Edit existing event.
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add actual submission to back-end.
                    sendEditRequest(
                        _calendarId.toString(),
                        _eventId,
                        startTime.text,
                        endTime.text,
                        _subjectText,
                        _description,
                        _location,
                        startdateinput.text,
                        enddateinput.text,
                        context);
                  },
                  child: const Text('Aanpassen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendDeleteRequest(_calendarId.toString(), _eventId);
                  },
                  child: const Text('Verwijderen'),
                )
              ],
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
  Event(this.eventId, this.calendarId, this.eventName, this.description,
      this.location, this.from, this.to, this.background, this.isAllDay);

  String eventId;
  int calendarId;
  String eventName;
  String description;
  String location;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
