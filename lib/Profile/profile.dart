import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/globals.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:ms18_applicatie/Models/roles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/apiManager.dart';
import '../Login/screens/components/onboding_screen.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final res = prefs.getString('token');
    String bearerToken = "Bearer $res";
    Map<String, String> headers = {
      ...apiHeaders,
      ...{"Authorization": bearerToken}
    };
    await ApiManager.get("api/v1/User/Logout", headers);
    prefs.remove('token');
    globalLoggedInUserValues = null;
    globalLoggedIn = false;
  }

  final TextEditingController emailController =
      TextEditingController(text: globalLoggedInUserValues?.email);
  final TextEditingController nameController =
      TextEditingController(text: globalLoggedInUserValues?.name);

  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
        "Profiel",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(mobilePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text("Naam:"),
              subtitle: Text(globalLoggedInUserValues?.name ?? ""),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              title: const Text("E-mail:"),
              subtitle: Text(globalLoggedInUserValues?.email ?? ""),
              contentPadding: EdgeInsets.zero,
            ),
            const PaddingSpacing(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Toegekende rechten",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (MapEntry<String, Roles> item in rolesDescription.entries)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.key),
                  CupertinoSwitch(
                      value:
                          globalLoggedInUserValues!.roles.contains(item.value),
                      onChanged: (onChanged) {}
                  )
                ],
              ),
            const PaddingSpacing(),
            Button(
              onTap: () {
                logout();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                    builder: (context) => const OnboardingScreen()), (T)=>false);
              },
              text: "Uitloggen",
              color: dangerColor,
              icon: Icons.logout,
              isFullWidth: false,
            ),
          ],
        ),
      ),
    );
  }
}
