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
           title: const Text(
             "Dashboard",
             style: TextStyle(
               color: Colors.white,
             ),
           ),
          appBarHeight: 70,
          child: const SizedBox(),
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
                  backgroundImage: Image.asset('assets/avatars/Avatar Default.png').image),
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
