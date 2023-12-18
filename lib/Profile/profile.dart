import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/profilePicture.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  final TextEditingController emailController =
      TextEditingController(text: "test@test.nl");
  final TextEditingController firstNameController =
      TextEditingController(text: "Danillo");
  final TextEditingController lastNameController =
      TextEditingController(text: "Van Kesteren");
  final TextEditingController dateOfBirthController =
      TextEditingController(text: "23-12-1942");

  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
        "Profile",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(mobilePadding),
        child: Column(
          children: [
            const PaddingSpacing(),
            const Row(
              children: [
                ProfilePicture(
                  size: 60,
                ),
                PaddingSpacing(),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Danillo",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: mainColor,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const PaddingSpacing(),
            const PaddingSpacing(),
            const PaddingSpacing(),
            InputField(
              isUnderlineBorder: true,
              labelText: "Email",
              controller: emailController,
            ),
            const PaddingSpacing(),
            InputField(
              isUnderlineBorder: true,
              labelText: "Voornaam",
              controller: firstNameController,
            ),
            const PaddingSpacing(),
            InputField(
              isUnderlineBorder: true,
              labelText: "Achternaam",
              controller: lastNameController,
            ),
            const PaddingSpacing(),
            InputField(
              isUnderlineBorder: true,
              labelText: "Geboorte datum",
              controller: dateOfBirthController,
            ),
            const PaddingSpacing(),
            const PaddingSpacing(),
            const PaddingSpacing(),
            Button(
              onTap: () {},
              text: "Uitloggen",
              icon: Icons.logout,
            ),
          ],
        ),
      ),
    );
  }
}
