import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Calendar/calendar.dart';
import 'package:ms18_applicatie/Dashboard/data/data.dart';

class PlaningGrid extends StatelessWidget {
  const PlaningGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: planing.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 0,
        childAspectRatio: 3.7,
        crossAxisCount: 1,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Handle the tap event and navigate to the desired page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Calendar()),
            );
          },
          child: Container(
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
                          color: planing[index].color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 55,
                        width: 55,
                        child: planing[index].icon,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        planing[index].heading,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        planing[index].subHeading,
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
          ),
        );
      },
    );
  }
}
