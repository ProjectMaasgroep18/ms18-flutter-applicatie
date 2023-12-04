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
  TextEditingController dateinput = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  bool shouldShowCreateForm = false;

  @override
  void initState() {
    dateinput.text = "";
    startTime.text = "";
    endTime.text = "";
    shouldShowCreateForm = false;
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
        shouldShowCreateForm = false;
        final Event appointmentDetails = details.appointments![0];
        _subjectText = appointmentDetails.eventName;
        _dateText = DateFormat('dd MMMM, yyyy')
            .format(appointmentDetails.from)
            .toString();
        _startTimeText =
            DateFormat('hh:mm a').format(appointmentDetails.from).toString();
        _endTimeText =
            DateFormat('hh:mm a').format(appointmentDetails.to).toString();
        _timeDetails = '$_startTimeText - $_endTimeText';

        // Use existing values.
        dateinput.text =
            DateFormat('dd MMMM, yyyy').format(appointmentDetails.from);
        startTime.text = _startTimeText!;
        endTime.text = _endTimeText!;

        break;
      case CalendarElement.calendarCell:
        shouldShowCreateForm = true;
        _startTimeText = DateFormat('hh:mm a').format(details.date!).toString();

        DateTime adjustedDateTime = details.date!.add(const Duration(hours: 1));

        _endTimeText = DateFormat('hh:mm a').format(adjustedDateTime);

        _subjectText = "Agenda item toevoegen";

        dateinput.text =
            DateFormat('dd MMMM, yyyy').format(details.date!).toString();
        startTime.text = DateFormat('hh:mm a').format(details.date!).toString();
        endTime.text = DateFormat('hh:mm a').format(adjustedDateTime);

        _timeDetails = "";
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
              height: 450,
              child: Column(
                children: <Widget>[
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Summary if updating existing.
                        if (!shouldShowCreateForm) ...[
                          Text(
                            _dateText!,
                          ),
                          Text(
                            _timeDetails!,
                          ),
                        ],

                        // Create / update event form.
                        TextFormField(
                          controller: dateinput,
                          decoration:
                              const InputDecoration(labelText: "Vul datum in"),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                locale: const Locale('nl', 'NL'),
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));
                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd--MM-YYYY').format(pickedDate);
                              setState(() {
                                dateinput.text = formattedDate;
                              });
                            }
                          },
                        ),
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
                                startTime.text =
                                    pickedStartTime.format(context);
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
                                endTime.text = pickedEndTime.format(context);
                              });
                            }
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText:
                                shouldShowCreateForm ? 'Titel' : _subjectText,
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: shouldShowCreateForm
                                ? 'Locatie'
                                : 'Oude Locatie',
                          ),
                        ),
                        TextFormField(
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: shouldShowCreateForm
                                ? 'Beschrijving'
                                : 'Oude Beschrijving',
                          ),
                        ),
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
              if (shouldShowCreateForm) ...[
                // Create new event.
                ElevatedButton(
                  onPressed: () {
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event aangepast')),
                    );
                  },
                  child: const Text('Aanpassen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add actual submission to back-end.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event verwijderd')),
                    );
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
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
