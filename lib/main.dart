import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Dashboard/dashboard.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/globals.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ms18_applicatie/Login/screens/components/onboding_screen.dart';
import 'package:ms18_applicatie/roles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/user.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  // Setting the default styles for the popups
  PopupAndLoading.baseStyle();

  runApp(Maasgroep18App());
}

void loadLocalUser(Map<String, dynamic> apiUser) {
  // Set global user info
  List<Roles> userRole = [];

  for (String role in apiUser["permissions"]) {
    switch (role) {
      case "admin":
        userRole.add(Roles.Admin);
      case "order.view":
        userRole.add(Roles.OrderView);
      case "order.product":
        userRole.add(Roles.OrderProduct);
      case "receipt":
        userRole.add(Roles.Receipt);
      case "receipt.approve":
        userRole.add(Roles.ReceiptApprove);
      case "receipt.pay":
        userRole.add(Roles.ReceiptPay);
      case "calendar.editor":
        userRole.add(Roles.CalendarEditor);
      default:
        userRole.add(Roles.Order);
    }
  }
  // Convert the color string from DB to Color
  String hexColor =
      "FF${((apiUser["color"] ?? "") as String).replaceAll('#', '')}";
  Color color = Color(int.tryParse(hexColor, radix: 16) ?? 0xFFFFFFFF);

  globalLoggedInUserValues = User(
    id: apiUser["id"],
    name: apiUser["name"],
    email: apiUser["email"] ?? "",
    password: "",
    roles: userRole,
    guest: apiUser["isGuest"],
    color: color,
  );
}

class Maasgroep18App extends StatelessWidget {
  Maasgroep18App({super.key});

  Future<bool> checkLogin() async {
    bool loggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getString('token');
    String bearerToken = "Bearer $res";
    Map<String, String> headers = {
      ...apiHeaders,
      ...{"Authorization": bearerToken}
    };
    await ApiManager.get("api/v1/User/Current", headers).then((value) async {
      if (value["error"] != null) {
        loggedIn = false;
      } else {
        loggedIn = true;
        print(value);
        loadLocalUser(value);
        globToken = await getToken();
      }
    }).catchError((error) {
      loggedIn = false;
    });
    return loggedIn;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      localizationsDelegates: <LocalizationsDelegate<Object>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: <Locale>[
        Locale('nl', 'NL'),
      ],
      navigatorKey: navigatorKey,
      title: 'Maasgroep 18 Applicatie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: secondColor),
        useMaterial3: true,
      ),
      home: FutureBuilder(
          future: checkLogin(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("error");
            } else if (snapshot.hasData) {
              if (snapshot.data == true) {
                globalLoggedIn = true;
                return const Dashboard();
              } else {
                return const OnboardingScreen();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
