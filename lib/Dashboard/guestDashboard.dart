import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Profile/profile.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:rive/rive.dart';

class GuestDashboard extends StatefulWidget {
  const GuestDashboard({super.key});

  @override
  State<GuestDashboard> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<GuestDashboard> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  Map<String, String> statistics = {"key":"ola"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Menu(
          appBarHeight: 270,
          centerTitle: false,
          child: const SizedBox(),
          title: const Text(
            "Gast Dashboard",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
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
                child: const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                      "https://avatars.githubusercontent.com/u/55942632?v=4"),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          width: MediaQuery.of(context).size.width * 1.7,
          bottom: 500,
          left: 100,
          child: Container(
            color: Colors.white,
          ),
        ),
        GridView.builder(
            itemCount: statistics.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15,
                childAspectRatio: 1,
                crossAxisCount: 2,
                mainAxisSpacing: 20),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.deepPurple,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "string",
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xff8EA3B7),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            width: 7,
                            decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          Text(
                            //statistics[index].number
                            "string",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff006ED3),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
              },
            )

      ],
    ));
  }
}

