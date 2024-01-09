import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Dashboard/data/data.dart';
import 'package:ms18_applicatie/Pictures/listPictures.dart';
import 'package:ms18_applicatie/team-c/Declarations/declarationsMenu.dart';

class StatisticsGrid extends StatelessWidget {
  const StatisticsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: statistics.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 15,
        childAspectRatio: 1.2,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            if (statistics[index].link == 'ListPictures') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPictures()),
              );
            } else if (statistics[index].link == 'DeclarationsMenu') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeclarationsMenu()),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    statistics[index].title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xff17203A),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statistics[index].number,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff17203A),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 7,
                        decoration: BoxDecoration(
                          color: Color(0xff17203A),
                          borderRadius: BorderRadius.circular(15),
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
