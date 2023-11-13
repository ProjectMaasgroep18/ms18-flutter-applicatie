import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:ms18_applicatie/Login/screens/components/onboding_screen.dart';

void main() {
  runApp(const Maasgroep18App());
}

class Maasgroep18App extends StatelessWidget {
  const Maasgroep18App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Maasgroep 18 Applicatie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: Menu(child: OnboardingScreen()),
    );
  }
}
