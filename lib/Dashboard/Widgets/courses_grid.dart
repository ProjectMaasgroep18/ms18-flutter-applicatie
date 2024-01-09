import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Dashboard/Widgets/planing_grid.dart';
import 'package:ms18_applicatie/Dashboard/data/data.dart';

class CourseGrid extends StatelessWidget {
  const CourseGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: course.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 16 / 8, crossAxisCount: 1, mainAxisSpacing: 10),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(20.0), // Set the border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Komende activiteit",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 58, 58, 58),
                          // decoration: TextDecoration.underline,
                          // decorationThickness:
                          //     3.0, // Adjust the thickness as needed
                          // decorationColor: Color.fromARGB(
                          //     255, 58, 58, 58), // Match the text color
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 340.5,
                        height: 100,
                        child: PlaningGrid(),
                      )
                      //
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
