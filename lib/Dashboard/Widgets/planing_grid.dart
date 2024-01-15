import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Calendar/calendar.dart';
import 'package:ms18_applicatie/Dashboard/data/data.dart';
import 'package:ms18_applicatie/Models/planning.dart';
import 'package:ms18_applicatie/config.dart';

class PlaningGrid extends StatelessWidget {
  final Planning planning;

  const PlaningGrid({Key? key,required this.planning}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 55,
                      width: 55,
                      child: Icon(
                        Icons.menu_book_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      planning.heading,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      planning.subHeading,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

  }
}
