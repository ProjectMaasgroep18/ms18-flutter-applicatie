import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/globals.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../menu.dart';
import 'package:ms18_applicatie/Models/roles.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';

const List<String> groups = [
  "Stam",
  "Matrozen",
  "Welpen",
  "ZeeVerkenners",
  "Globaal"
];

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

var StamFilter = false;
var MatrozenFilter = false;
var WelpenFilter = false;
var ZeeVerkennersFilter = false;
var GlobalFilter = true;
var GlobalSource = apiUrl + 'Calendar/all';

class InputDropDown extends StatefulWidget {
  InputDropDown(
      {super.key,
      required this.items,
      this.value,
      this.onChange,
      this.hintText,
      this.isUnderlineBorder = true,
      this.labelText});

  final List<DropdownMenuItem<String>> items;
  final Function(String? value)? onChange;
  final String? hintText;
  final String? labelText;
  final bool isUnderlineBorder;
  String? value;

  @override
  State<InputDropDown> createState() => _InputDropDownState();
}

class _InputDropDownState extends State<InputDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: widget.items,
      value: widget.value,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
            vertical: 10, horizontal: widget.isUnderlineBorder ? 0 : 15),
        isDense: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: const TextStyle(
          color: mainColor,
          fontWeight: FontWeight.w300,
        ),
        enabledBorder:
            widget.isUnderlineBorder ? inputUnderlineBorder : inputBorder,
        focusedBorder:
            widget.isUnderlineBorder ? inputUnderlineBorder : inputBorder,
        border: widget.isUnderlineBorder ? inputUnderlineBorder : inputBorder,
      ),
      onChanged: (newValue) {
        if (widget.onChange != null) widget.onChange!(newValue);

        setState(() {
          widget.value = newValue;
        });
      },
    );
  }
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
  TextEditingController startDateInput = TextEditingController();
  TextEditingController endDateInput = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  String group = "Globaal";
  bool isNewEvent = false;
  bool isReadOnly = false;

  final restfulUrl = apiUrl + 'Calendar/Event';

  String source = apiUrl + 'Calendar/all';
  String lastSource = '';

  Future<void> sendDeleteRequest(calendarName, id, contextForm) async {
    PopupAndLoading.showLoading();
    var response = await http.delete(
        Uri.parse(restfulUrl).replace(queryParameters: {
          'calendarName': calendarName,
          'id': id,
        }),
        headers: getHeaders());

    PopupAndLoading.endLoading();
    if (response.statusCode == 200) {
      PopupAndLoading.showSuccess("Event verwijderd");
    } else {
      PopupAndLoading.showError("Event is niet verwijderd, probeer opnieuw");
    }
    await _fetchDataAsync(GlobalSource);
    Navigator.of(contextForm).pop();
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
    PopupAndLoading.showLoading();

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
        headers: getHeaders());

    PopupAndLoading.endLoading();
    if (response.statusCode == 200) {
      PopupAndLoading.showSuccess("Event aangepast");
    } else {
      PopupAndLoading.showError("Event is niet aangepast, probeer opnieuw");
      return;
    }
    await _fetchDataAsync(GlobalSource);
    Navigator.of(contextForm).pop();
  }

  Future<void> sendCreateRequest(calendarName, id, startTime, endTime, title,
      description, location, endDate, startDate, contextForm) async {
    PopupAndLoading.showLoading();
    var formattedFromStr =
        DateTime.parse(startDate + " " + startTime).toIso8601String();
    var formattedToStr =
        DateTime.parse(endDate + " " + endTime).toIso8601String();

    var response = await http.post(
        Uri.parse(restfulUrl).replace(queryParameters: {
          'calendarName': calendarName,
          'StarDateTime': formattedFromStr,
          'EndDateTime': formattedToStr,
          'Title': title,
          'Description': description,
          'id': "",
          'Location': location,
          'CalendarId': calendarName
        }),
        headers: getHeaders());

    PopupAndLoading.endLoading();
    if (response.statusCode == 200) {
      PopupAndLoading.showSuccess('Event aangemaakt');
    } else {
      PopupAndLoading.showError('Event is niet aangemaakt, probeer opnieuw');
      return;
    }
    await _fetchDataAsync(GlobalSource);
    Navigator.of(contextForm).pop();
  }

  @override
  void initState() {
    startDateInput.text = "";
    endDateInput.text = "";
    startTime.text = "";
    endTime.text = "";
    isNewEvent = false; // Whether form is creating or updating event.
    _description = "";
    _location = "";
    super.initState();

    source = apiUrl + 'Calendar/all';
    lastSource = '';
    _fetchDataAsync(source);
  }

  Future<void> _fetchDataAsync(String source) async {
    GlobalSource = source;
    PopupAndLoading.showLoading();
    try {
      var data = await _getDataSourceAsync(source);
      setState(() {
        lastSource = source;
        events = data;
      });
    } catch (exeption) {
      PopupAndLoading.showError("Ophalen van data is mislukt :(");
    } finally {
      PopupAndLoading.endLoading();
    }
  }

  Future<List<Event>> _getDataSourceAsync(String source) async {
    String url = source;

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
          var color = Colors.black;
          switch (calendarId) {
            case 0:
              color = Color.fromARGB(255, 230, 108, 23);
            case 1:
              color = Color.fromARGB(255, 181, 49, 81);
            case 2:
              color = Color.fromARGB(255, 162, 198, 91);
            case 3:
              color = Color.fromARGB(255, 240, 166, 0);
            case 4:
              color = Colors.blue;
          }

          final event = Event(
            eventId,
            calendarId,
            eventName,
            description,
            location,
            startDateTime,
            endDateTime,
            color, // Vervang dit door de juiste achtergrondkleur
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
    double imageSize =
        MediaQuery.of(context).size.width > mobileWidth ? 110.0 : 55.0;

    return Menu(
      title: const Text(
        "Agenda",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      child: SizedBox(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color:
                        GlobalFilter ? backgroundColorDark : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        StamFilter = false;
                        GlobalFilter = true;
                        WelpenFilter = false;
                        ZeeVerkennersFilter = false;
                        MatrozenFilter = false;
                        setState(() {
                          _fetchDataAsync(apiUrl + 'Calendar/All');
                        });
                      },
                      child: ClipRRect(
                        child: Image.asset('assets/groups/globaal.png',
                            width: imageSize, height: imageSize),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        WelpenFilter ? backgroundColorDark : Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        StamFilter = false;
                        GlobalFilter = false;
                        WelpenFilter = true;
                        ZeeVerkennersFilter = false;
                        MatrozenFilter = false;
                        setState(() {
                          _fetchDataAsync(apiUrl + 'Calendar/welpen');
                        });
                      },
                      child: ClipRRect(
                        child: Image.asset('assets/groups/welpen.png',
                            width: imageSize, height: imageSize),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: ZeeVerkennersFilter
                        ? backgroundColorDark
                        : Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _fetchDataAsync(apiUrl + 'Calendar/ZeeVerkenners');
                        });
                        StamFilter = false;
                        GlobalFilter = false;
                        WelpenFilter = false;
                        ZeeVerkennersFilter = true;
                        MatrozenFilter = false;
                      },
                      child: ClipRRect(
                        child: Image.asset('assets/groups/zee_verkenner.png',
                            width: imageSize, height: imageSize),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color: MatrozenFilter
                        ? backgroundColorDark
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _fetchDataAsync(apiUrl + 'Calendar/matrozen');
                        });
                        StamFilter = false;
                        GlobalFilter = false;
                        WelpenFilter = false;
                        ZeeVerkennersFilter = false;
                        MatrozenFilter = true;
                      },
                      child: ClipRRect(
                        child: Container(
                          child: Image.asset(
                            'assets/groups/matrozen.png',
                            width: imageSize,
                            height: imageSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        StamFilter ? backgroundColorDark : Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        StamFilter = true;
                        GlobalFilter = false;
                        WelpenFilter = false;
                        ZeeVerkennersFilter = false;
                        MatrozenFilter = false;
                        setState(() {
                          _fetchDataAsync(apiUrl + 'Calendar/stam');
                        });
                      },
                      child: ClipRRect(
                        child: Image.asset('assets/groups/stam.png',
                            width: imageSize, height: imageSize),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SfCalendar(
                view: MediaQuery.of(context).size.width > mobileWidth
                    ? CalendarView.month
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
                allowedViews: [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.month,
                  CalendarView.schedule,
                ],
                monthViewSettings: const MonthViewSettings(
                    navigationDirection: MonthNavigationDirection.vertical,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment),
              ),
            ),
          ],
        ),
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
        if (globalLoggedInUserValues!.roles != null) {
          if (!globalLoggedInUserValues!.roles.contains(Roles.CalendarEditor) &&
              !globalLoggedInUserValues!.roles.contains(Roles.Admin)) {
            isReadOnly = true;
          }
        } else {
          isReadOnly = true;
        }
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

        _endDateText =
            DateFormat('yyyy-MM-dd').format(appointmentDetails.to).toString();
        _endTimeText = DateFormat('HH:mm').format(appointmentDetails.to);
        _timeDetails = '$_startTimeText - $_endTimeText';

        // Use existing values.
        startTime.text = _startTimeText!;
        endTime.text = _endTimeText!;
        startDateInput.text = _startDateText!;
        endDateInput.text = _endDateText!;
        break;
      case CalendarElement.calendarCell:
        if (globalLoggedInUserValues!.roles != null) {
          if (!globalLoggedInUserValues!.roles.contains(Roles.CalendarEditor) &&
              !globalLoggedInUserValues!.roles.contains(Roles.Admin)) {
            return;
          }
        } else {
          return;
        }
        isNewEvent = true;
        _startTimeText = DateFormat('HH:mm').format(details.date!).toString();

        DateTime adjustedDateTime = details.date!.add(const Duration(hours: 1));

        _endTimeText = DateFormat('HH:mm').format(adjustedDateTime);

        _subjectText = "Agenda item toevoegen";

        startDateInput.text =
            DateFormat('yyyy-MM-dd').format(details.date!).toString();
        endDateInput.text =
            DateFormat('yyyy-MM-dd').format(details.date!).toString();

        startTime.text = DateFormat('HH:mm').format(details.date!).toString();
        endTime.text = DateFormat('HH:mm').format(adjustedDateTime);
        _timeDetails = "";
        TimeOfDay? pickedStartTime2 = null;
        break;
      default:
        return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$_subjectText'),
            content: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Create / update event form.
                          TextFormField(
                              controller: startDateInput,
                              readOnly: true,
                              decoration: InputDecoration(
                                  labelText: isReadOnly
                                      ? "Startdatum"
                                      : "Vul startdatum in"),
                              onTap: () async {
                                if (!isReadOnly) {
                                  DateTime? pickedDate = await showDatePicker(
                                      locale: const Locale('nl', 'NL'),
                                      context: context,
                                      initialDate: isNewEvent
                                          ? DateTime.now()
                                          : DateTime.parse(_startDateText!),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2101));
                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate)
                                            .toString();
                                    setState(() {
                                      startDateInput.text = formattedDate;
                                    });
                                  }
                                }
                              },
                              onChanged: (String? newValue) {
                                _startDateText = newValue;
                              }),
                          TextFormField(
                              controller: endDateInput,
                              decoration: InputDecoration(
                                  labelText: isReadOnly
                                      ? "Einddatum"
                                      : "Vul einddatum in"),
                              readOnly: true,
                              onTap: () async {
                                if (!isReadOnly) {
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
                                      endDateInput.text = formattedEndDate;
                                    });
                                  }
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
                              if (!isReadOnly) {
                                TimeOfDay? pickedStartTime =
                                    await showTimePicker(
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
                                    startTime.text = pickedStartTime
                                        .format(context)
                                        .toString();
                                  });
                                }
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
                              if (!isReadOnly) {
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
                                    endTime.text = pickedEndTime
                                        .format(context)
                                        .toString();
                                  });
                                }
                              }
                            },
                          ),
                          if (!isReadOnly) ...[
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Titel',
                              ),
                              initialValue: isNewEvent ? "" : _subjectText,
                              readOnly: isReadOnly,
                              onChanged: (String? value) {
                                _subjectText = value;
                              },
                            ),
                          ],
                          TextFormField(
                              decoration: InputDecoration(labelText: "Locatie"),
                              initialValue: isNewEvent ? "" : _location,
                              readOnly: isReadOnly,
                              onChanged: (String? value) {
                                _location = value;
                              }),
                          if (isNewEvent) ...[
                            InputDropDown(
                              labelText: "Groep",
                              value: groups.contains(group) ? group : null,
                              items: [
                                for (String item in groups)
                                  DropdownMenuItem(
                                    value: item,
                                    child: InputDropdownItem(
                                      groupName: item,
                                    ),
                                  )
                              ],
                              onChange: (newValue) {
                                group = newValue ?? 'Globaal';
                              },
                            ),
                          ],
                          TextFormField(
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              decoration:
                                  InputDecoration(labelText: "Beschrijving"),
                              initialValue: isNewEvent ? "" : _description,
                              readOnly: isReadOnly,
                              onChanged: (String? value) {
                                _description = value;
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Sluiten')),
              if (!isReadOnly) ...[
                if (isNewEvent) ...[
                  // Create new event.
                  SizedBox(
                    width: 100,
                    child: Button(
                      onTap: () {
                        sendCreateRequest(
                            groups.indexOf(group).toString(),
                            _eventId,
                            startTime.text,
                            endTime.text,
                            _subjectText,
                            _description,
                            _location,
                            startDateInput.text,
                            endDateInput.text,
                            context);
                      },
                      text: 'Toevoegen',
                    ),
                  ),
                ] else ...[
                  // Edit existing event.
                  SizedBox(
                    width: 100,
                    child: Button(
                      onTap: () {
                        sendEditRequest(
                            _calendarId.toString(),
                            _eventId,
                            startTime.text,
                            endTime.text,
                            _subjectText,
                            _description,
                            _location,
                            startDateInput.text,
                            endDateInput.text,
                            context);
                      },
                      text: 'Aanpassen',
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Button(
                      onTap: () {
                        sendDeleteRequest(
                            _calendarId.toString(), _eventId, context);
                      },
                      text: 'Verwijderen',
                      color: dangerColor,
                    ),
                  )
                ],
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

class InputDropdownItem extends StatelessWidget {
  const InputDropdownItem({super.key, required this.groupName});
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [Text(groupName)],
      ),
    );
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
