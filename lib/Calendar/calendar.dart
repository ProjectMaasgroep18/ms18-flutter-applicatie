import 'package:flutter/material.dart';

import '../menu.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Menu(child: Text("Ga vanaf hier verder"));
  }
}