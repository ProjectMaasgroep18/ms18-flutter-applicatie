import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Users/functions.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/profilePicture.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:ms18_applicatie/roles.dart';

import '../Widgets/buttons.dart';
import '../config.dart';

const Map<String, Roles> roles = {
  "Admin": Roles.Admin,
  "Orders bekijken": Roles.OrderView,
  "Order product": Roles.OrderProduct,
  "Declaraties aanmaken": Roles.Receipt,
  "Declaraties goedkeuren": Roles.ReceiptApprove,
  "Declaraties betalen": Roles.ReceiptPay,
};

Future<void> addUsersDialog(BuildContext context, Function(User user) onSave,
    [Function()? onDelete, User? user]) async {
  bool isChange = user != null;
  // Check if user is guest, but only if it is not a new user
  bool isGuest = false;
  if (isChange) isGuest = user.role == Roles.Guest;
  final ValueNotifier<bool> guestCheckboxState = ValueNotifier<bool>(false);

  user ??= User(id: 0, name: "", email: "", password: "", role: Roles.Guest);

  TextEditingController nameController = TextEditingController(text: user.name);
  TextEditingController emailController =
      TextEditingController(text: user.email);
  TextEditingController passwordController =
      TextEditingController(text: user.password);
  Roles userRole = user.role;

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
                CupertinoSwitch(
                  activeColor: mainColor,
                  value: guestCheckboxState.value,
                  onChanged: (value) {
                    isGuest = value;
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
                return Visibility(
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: false,
                  child: Column(
                    children: [
                      InputField(
                        controller: passwordController,
                        labelText: "Wachtwoord",
                        isUnderlineBorder: true,
                        isPassword: true,
                      ),
                      const PaddingSpacing(),
                      InputDropDown(
                        labelText: "Rol",
                        value: roles.keys.firstWhere(
                                (element) => roles[element] == userRole,
                            orElse: () => roles.keys.first),
                        items: [
                          for (String role in roles.keys)
                            DropdownMenuItem(
                              value: role,
                              child: Row(
                                  children: [
                                    const PaddingSpacing(),
                                    Text(role)
                                  ]),
                            )
                        ],
                      )
                    ],
                  )
                );
              } else {
                return Column(
                  children: [
                    InputField(
                      controller: passwordController,
                      labelText: "Wachtwoord",
                      isUnderlineBorder: true,
                      isPassword: true,
                    ),
                    const PaddingSpacing(),
                    InputDropDown(
                      labelText: "Rol",
                      value: roles.keys.firstWhere(
                          (element) => roles[element] == userRole,
                          orElse: () => roles.keys.first),
                      items: [
                        for (String role in roles.keys)
                          DropdownMenuItem(
                            value: role,
                            child: Row(
                                children: [
                                  const PaddingSpacing(),
                                  Text(role)
                                ]),
                          )
                      ],
                      onChange: (newValue) {
                        userRole = roles[newValue] ?? Roles.Guest;
                      },
                    )
                  ],
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
    if(isGuest) userRole = Roles.Guest;
    user!
      ..name = nameController.text
      ..email = emailController.text
      ..password = passwordController.text
      ..role = userRole;
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
              child: Text("Vul je wachtwoord door te gaan")),
          InputField(
            isPassword: true,
            controller: passwordController,
          )
        ],
      ), onSave: () {
    Navigator.of(context).pop();
  });
  return passwordController.text;;
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
      leading: const ProfilePicture(),
      title: Text(user.name),
      subtitle: Text(user.email),
      contentPadding: EdgeInsets.zero,
    );
  }
}
