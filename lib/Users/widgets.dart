import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Orders/orders.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Models/roles.dart';

import '../Widgets/buttons.dart';
import '../config.dart';

Future<void> addUsersDialog(BuildContext context, Function(User user) onSave,
    [Function()? onDelete, User? user]) async {
  bool isChange = user != null;

  // Check if user is guest, but only if it is not a new user
  bool isGuest = false;
  if (isChange) isGuest = user.guest;
  final ValueNotifier<bool> guestCheckboxState = ValueNotifier<bool>(isGuest);

  user ??= User(
      id: 0,
      name: "",
      email: "",
      password: "",
      roles: [Roles.Order],
      guest: true,
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);

  // Values for the roles checkboxes

  Map<String, ValueNotifier<bool>> rolesCheckboxValues = {};

  rolesDescription.forEach((key, value) {
    rolesCheckboxValues[key] = ValueNotifier<bool>(user!.roles.contains(value));
  });

  TextEditingController nameController = TextEditingController(text: user.name);
  TextEditingController emailController =
      TextEditingController(text: user.email);
  TextEditingController passwordController =
      TextEditingController(text: user.password);
  List<Roles> userRole = user.roles;

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
          valueListenable: guestCheckboxState,
          builder: (BuildContext context, dynamic value, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Gast gebruiker'),
                // Disable switch if it is not a new user
                if (isChange)
                  CupertinoSwitch(
                    activeColor: mainColor,
                    value: guestCheckboxState.value,
                    onChanged: (value) {},
                  )
                else
                  CupertinoSwitch(
                    activeColor: mainColor,
                    value: guestCheckboxState.value,
                    onChanged: (value) {
                      isGuest = value;
                      isGuest ? user?.roles = [Roles.Order] : null;
                      guestCheckboxState.value = value;
                    },
                  ),
              ],
            );
          },
        ),
        ValueListenableBuilder(
            valueListenable: guestCheckboxState,
            builder: (BuildContext context, dynamic value, Widget? child) {
              // If it is a new user, allow a password to be entered and role to be assigned
              if (isGuest) {
                return const PaddingSpacing();
              } else {
                return Column(children: [
                  // Show password is not required when it is not a new user
                  if (isChange)
                    InputField(
                      controller: passwordController,
                      labelText: "Wachtwoord (laat leeg om niet te veranderen)",
                      isUnderlineBorder: true,
                      isPassword: true,
                    )
                  else
                    InputField(
                      controller: passwordController,
                      labelText: "Wachtwoord",
                      isUnderlineBorder: true,
                      isPassword: true,
                      isRequired: true,
                    ),

                  const PaddingSpacing(),

                  // For each Role in rolesCheckboxValues, create a checkbox with ValueNotifier
                  for (MapEntry<String, ValueNotifier<bool>> item
                      in rolesCheckboxValues.entries)
                    ValueListenableBuilder(
                      // item.key = Text for checkbox
                      // item.value = ValueNotifier
                      // item.value.value = bool value from the ValueNotifier
                      valueListenable: item.value,
                      builder:
                          (BuildContext context, dynamic value, Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.key),
                            CupertinoSwitch(
                              activeColor: mainColor,
                              value: item.value.value,
                              onChanged: (value) {
                                item.value.value = value;

                                Roles? role = rolesDescription[item.key];
                                if (user!.roles.contains(role)) {
                                  user.roles.remove(role);
                                } else {
                                  user.roles.add(role!);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    ),
                ]);
              }
            }),
        if (onDelete != null) ...[
          const PaddingSpacing(),
          Button(
            onTap: onDelete,
            color: dangerColor,
            text: "Verwijderen",
            icon: Icons.delete,
          ),
          if (user.guest) ...[
            const PaddingSpacing(),
            Button(
              icon: Icons.receipt_long,
              text: 'Bestellingen bekijken',
              onTap: () {
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => Orders(
                      userId: user?.id,
                    ),
                  ),
                );
              },
            )
          ]
        ]
      ]), onSave: () {
    // Ensure that guest user has the right role
    if (isGuest) userRole = [Roles.Order];

    user!
      ..name = nameController.text
      ..email = emailController.text
      ..password = passwordController.text
      ..roles = userRole
      ..guest = isGuest
      ..color = user.color;
    onSave(user);
  });
}

Future<String> askPasswordConfirmation(BuildContext context) async {
  TextEditingController passwordController = TextEditingController();

  await showInputPopup(context,
      title: "Wachtwoord ter controle",
      child: Column(
        children: [
          const Align(
              alignment: Alignment.topLeft,
              child: Text("Vul je eigen wachtwoord door te gaan")),
          InputField(
            isPassword: true,
            controller: passwordController,
          )
        ],
      ), onSave: () {
    Navigator.of(context).pop();
  });
  return passwordController.text;
}

Widget rolesCheckboxes(Map<String, ValueNotifier<bool>> rolesCheckboxValues) {
  List<Widget> widgetList = [];

  for (MapEntry<String, ValueNotifier<bool>> item
      in rolesCheckboxValues.entries) {
    Widget tempWidget = ValueListenableBuilder(
        valueListenable: item.value,
        builder: (BuildContext context, dynamic value, Widget? child) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.key),
                CupertinoSwitch(
                  activeColor: mainColor,
                  value: item.value.value,
                  onChanged: (value) {
                    item.value.value;
                  },
                )
              ]);
        });
    widgetList.add(tempWidget);
  }
  return Column(children: widgetList);
}

class UserElement extends StatelessWidget {
  final User user;
  final Function() onDelete;
  final Function(User) onSave;

  UserElement(
      {required this.user, required this.onDelete, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        addUsersDialog(context, onSave, onDelete, user);
      },
      leading: SizedBox(
        width: 45,
        height: 45,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: user.color,
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(2, 2), // changes position of shadow
                ),
              ],
            ),
          ),
        ]),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      contentPadding: EdgeInsets.zero,
    );
  }
}
