import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
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
        body: Stack(
      children: [
        Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset('assets/Backgrounds/Spline.png')),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
        )),
        const RiveAnimation.asset('assets/RiveAssets/shapes.riv'),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          child: const SizedBox(),
        )),
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
                  const PaddingSpacing(),
                  const PaddingSpacing(),
                  const PaddingSpacing(),
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
