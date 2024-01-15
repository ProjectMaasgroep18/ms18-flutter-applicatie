import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Calendar/calendar.dart';
import 'package:ms18_applicatie/Dashboard/Widgets/planing_grid.dart';
import 'package:ms18_applicatie/Dashboard/data/data.dart';
import 'package:ms18_applicatie/Dashboard/functions.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/config.dart';

import '../../menu.dart';

class CourseGrid extends StatelessWidget {
  const CourseGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        MenuIndex.index=5;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const Calendar()),
        );
      },
      child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(2, 2), // changes position of shadow
                    ),
                  ]// Set the border radius
              ),
              child: Padding(
                padding: const EdgeInsets.all(mobilePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Komende activiteit",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 58, 58, 58),
                      ),
                    ),
                   const PaddingSpacing(),
                    FutureBuilder(
                        future: getPlanning(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.hasData) {
                            return PlaningGrid(planning: snapshot.data[0]);
                          }
                          return SizedBox();
                        })
                  ],
                ),
              ),
            ),
    );
  }
}
