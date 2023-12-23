import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/profilePicture.dart';

import '../Widgets/buttons.dart';
import '../config.dart';

Future<void> addUsersDialog(BuildContext context, Function(User user) onSave,
    [Function()? onDelete, User? user]) async {
  bool isChange = user != null;
  bool isGuest = false;
  if (isChange) isGuest = user.guest;
  final ValueNotifier<bool> checkboxState = ValueNotifier<bool>(false);
  print("PRINT ${user?.name}");

  user ??= User(id:0, name: "", email: "", hashedPassword: "", guest: false);
  TextEditingController nameController = TextEditingController(text: user.name);
  TextEditingController emailController =
      TextEditingController(text: user.email);
  TextEditingController passwordController =
      TextEditingController(text: user.hashedPassword);

  await showInputPopup(context,
      title: "Gebruiker ${isChange ? 'wijzigen' : 'toevoegen'}",
      height: 250 + (isChange ? 48 : 0),
      child: Column(children: [
        InputField(
          controller: nameController,
          labelText: "Naam",
          isUnderlineBorder: true,
        ),
        const PaddingSpacing(),
        InputField(
          controller: emailController,
          labelText: "E-mail",
          isUnderlineBorder: true,
        ),
        const PaddingSpacing(),
        ValueListenableBuilder(
          valueListenable: checkboxState,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Gast gebruiker'),
                  CupertinoSwitch(
                    activeColor: mainColor,
                    value: checkboxState.value,
                    onChanged: (value) {
                      isGuest = value;
                      checkboxState.value = value;
                    },
                  ),
                ],
              ),
            );
          },
        ),
        ValueListenableBuilder(
            valueListenable: checkboxState,
            builder: (BuildContext context, dynamic value, Widget? child) {
              // If it is a new user, allow a password to be entered

              if (isGuest) {
                return Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: false,
                  child: InputField(
                    controller: passwordController,
                    labelText: "Wachtwoord",
                    isUnderlineBorder: true,
                    isPassword: false,
                  ),
                );
              } else {
                return InputField(
                  controller: passwordController,
                  labelText: "Wachtwoord",
                  isUnderlineBorder: true,
                  isPassword: true,
                );
              }
            }),
        if (onDelete != null) ...[
          const PaddingSpacing(),
          Button(
              onTap: onDelete,
              color: dangerColor,
              text: "Verwijderen",
              icon: Icons.delete)
        ]
      ]), onSave: () {
    user!
      ..name = nameController.text
      ..email = emailController.text
      ..hashedPassword = passwordController.text
      ..guest = isGuest;
    onSave(user);
  });
}

class UserElement extends StatelessWidget {
  final User user;
  final Function() onDelete;

  UserElement({required this.user,
    required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        addUsersDialog(context, (user) async {
          // await updateUser(user);
        }, onDelete, user);
      },
      leading: const ProfilePicture(),
      title: Text(user.name),
      subtitle: Text(user.email),
      contentPadding: EdgeInsets.zero,
    );
  }
}
