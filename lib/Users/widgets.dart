import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/profilePicture.dart';
import 'package:ms18_applicatie/config.dart';

class UserElement extends StatelessWidget {
  final User user;
  final Function(String)? onChange;

  const UserElement({
    required this.user,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const ProfilePicture(),
      title: Text(user.fullName),
      subtitle: Text(user.email),
    );
  }
}

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  bool isGuest = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const InputField(
          labelText: "Email",
          isUnderlineBorder: true,
        ),
        const PaddingSpacing(),
        const InputField(
          labelText: "Voornaam",
          isUnderlineBorder: true,
        ),
        const PaddingSpacing(),
        const InputField(
          labelText: "Achternaam",
          isUnderlineBorder: true,
        ),
        const PaddingSpacing(),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gast gebruiker'),
              CupertinoSwitch(
                activeColor: mainColor,
                value: isGuest,
                onChanged: (value) {
                  setState(() {
                    isGuest = !isGuest;
                  });
                },
              ),
            ],
          ),
        ),
        if (!isGuest)
          const InputField(
            labelText: "Wachtwoord",
            isUnderlineBorder: true,
          ),
      ],
    );
  }
}
