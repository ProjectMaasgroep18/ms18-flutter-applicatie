import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Dashboard/data/data.dart';
import 'package:ms18_applicatie/Dashboard/functions.dart';
import 'package:ms18_applicatie/Pictures/listPictures_depr.dart';
import 'package:ms18_applicatie/team-c/Declarations/declarationsMenu.dart';

import '../../menu.dart';

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
              MenuIndex.index=2;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPictures()),
              );
            } else if (statistics[index].link == 'DeclarationsMenu') {
              MenuIndex.index=3;
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(2, 2), // changes position of shadow
                  ),
                ]
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
                      FutureBuilder(future: getDeclarationsCount(), builder: (context ,snapshot){
                        if(snapshot.hasData){
                          return Text(
                            (index == 1 ? snapshot.data : 0).toString(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff17203A),
                            ),
                          );
                        }
                        return SizedBox();
                      }) ,
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
