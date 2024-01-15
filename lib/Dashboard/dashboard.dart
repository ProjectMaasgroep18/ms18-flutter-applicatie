import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Dashboard/Widgets/courses_grid.dart';
import 'package:ms18_applicatie/Dashboard/Widgets/planing_grid.dart';
import 'package:ms18_applicatie/Dashboard/Widgets/statistics_grid.dart';
import 'package:ms18_applicatie/Dashboard/data/data.dart';
import 'package:ms18_applicatie/Profile/profile.dart';
import 'package:ms18_applicatie/Stock/stockReport.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:rive/rive.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<Dashboard> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      appBarHeight: 70,
      centerTitle: false,
      title: const Text(
        "Dashboard",
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.white, fontSize: 24),
      ),
      actions: [
        // profile picture in appbar
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => Profile())));
            },
            child: CircleAvatar(
              radius: 22,
              backgroundImage: Image.asset('assets/avatars/Avatar Default.jpg').image
            ),
          ),
        ),
      ],
      child: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Container(
              color: Color.fromARGB(255, 2, 2, 2),
            ),
          ),
          SizedBox(
            height: 500,
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const CourseGrid(),
                  const SizedBox(
                    height: 20,
                  ),
                  const StatisticsGrid(),
                  const SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    itemCount: course.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 16 / 7,
                            crossAxisCount: 1,
                            mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/box/box7.png"),
                              fit: BoxFit.fill),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StockReport()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Werk de \nvoorraad bij",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "poppins",
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/Left-Arrow.png",
                                      height: 110,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Text('Image not found');
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
