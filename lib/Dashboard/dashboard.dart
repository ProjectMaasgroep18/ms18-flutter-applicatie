import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Profile/profile.dart';
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
    return Scaffold(
        body: Stack(
      children: [
         Menu(
          appBarHeight: 70,
          centerTitle: false,
          child: const SizedBox(),
          title: const Text(
            "Dashboard",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
          bottom: 200,
          left: 100,
          child: Container(
            color: Colors.white,
          ),
        ),
      ],
    ));
  }
}
