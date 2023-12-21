import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:rive/rive.dart';
import 'components/custom_sign_in.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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

        body: Padding(
      padding: const EdgeInsets.all(0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 3,
                // bottom: -5350,
                // left: -2760,
                child: Image.asset('assets/Backgrounds/Shapes.png')),
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          )),
          // const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
          // Positioned.fill(
          //     child: BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          //   child: const SizedBox(),
          // )),
          AnimatedPositioned(
            duration: Duration(milliseconds: 240),
            top: isSignInDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Image.asset(
                      "assets/logo.jpg",
                      width: 50,
                    ),
                    const SizedBox(
                      width: 260,
                      child: Column(children: [
                        Text(
                          "Welkom Terug",
                          style: TextStyle(
                              fontSize: 60,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              height: 1.2),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text("")
                      ]),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    Button(
                      text: 'Sign in',
                      icon: Icons.arrow_forward,
                      onTap: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(const Duration(milliseconds: 800), () {
                          setState(() {
                            isSignInDialogShown = true;
                          });
                          customSigninDialog(context, onClosed: (_) {
                            setState(() {
                              isSignInDialogShown = false;
                            });
                          });
                        });
                      },
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          _btnAnimationController.isActive = true;
                          Future.delayed(const Duration(milliseconds: 800), () {
                            setState(() {
                              isSignInDialogShown = true;
                            });
                            customGuestLogin(context, onClosed: (_) {
                              setState(() {
                                isSignInDialogShown = false;
                              });
                            });
                          });
                        },
                        child: Text(
                          "Gast Login",
                          style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const PaddingSpacing(),
                    const PaddingSpacing(),
                    const PaddingSpacing(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
