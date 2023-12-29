import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Users/userList.dart';
import 'package:ms18_applicatie/Users/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/apiManager.dart';
import '../Models/user.dart';
import '../Widgets/popups.dart';
import '../config.dart';
import '../roles.dart';

const String url = "api/v1/User";

Future<Map<String, String>> getHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final res = prefs.getString('token');
  String bearerToken = "Bearer $res";
  return {
    ...apiHeaders,
    ...{"Authorization": bearerToken}
  };
}

void reloadPage() {
  navigatorKey.currentState!.pushReplacement(
      MaterialPageRoute(builder: ((context) => const UserList())));
}

Future<List<User>> getUsers() async {
  List<User> userList = [];
  await ApiManager.get<List<dynamic>>(url, await getHeaders()).then((data) {
    for (Map<String, dynamic> apiUser in data) {
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
          default:
            userRole.add(Roles.Order);
        }
      }

      // Convert the color string from DB to Color
      String hexColor =
          "FF${((apiUser["color"] ?? "") as String).replaceAll('#', '')}";
      Color color = Color(int.tryParse(hexColor, radix: 16) ?? 0xFFFFFFFF);

      User tempUser = User(
        id: apiUser["id"],
        name: apiUser["name"],
        email: apiUser["email"] ?? "",
        password: "",
        roles: userRole,
        guest: apiUser["isGuest"],
        color: color,
      );
      userList.add(tempUser);
    }
  });
  return userList;
}

Future addUser(User user, BuildContext context) async {
  String color = "#${user.color.value.toRadixString(16).substring(2)}";
  Map<String, dynamic> body = {
    'name': user.name,
    'email': user.email,
    'color': color
  };

  PopupAndLoading.showLoading();
  await ApiManager.post(url, body, await getHeaders()).then((value) async {
    /* value is all user info, including ID. This is required to update the user
    /  Creating only allow to send name, email and color so a second request is
    /  required to change any permissions, password, etc.  */
    user.id = value["id"];
    PopupAndLoading.endLoading();
    await updateUser(user, context, isChange: false);
    reloadPage();
  }).catchError((error) {
    print(error);
    PopupAndLoading.showError("Gebruiker toevoegen mislukt");
  });
  PopupAndLoading.endLoading();
}

Future deleteUser(int userID) async {
  await ApiManager.delete("$url/$userID", await getHeaders()).then((value) {
    PopupAndLoading.showSuccess("Gebruiker verwijderen gelukt");
    reloadPage();
  }).catchError((error) {
    PopupAndLoading.showError("Gebruiker verwijderen mislukt");
  });
  PopupAndLoading.endLoading();
}

Future updateUser(User user, BuildContext context,
    {bool isChange = true}) async {
  // Ask for confirmation via password
  String currentUserPassword = await askPasswordConfirmation(context);

  // Convert Roles to string to use in database
  List<String> dbRoles = [];
  for (Roles role in user.roles) {
    String userRole =
        rolesToDB.keys.firstWhere((element) => rolesToDB[element] == role);
    dbRoles.add(userRole);
  }

  Map<String, dynamic> body = {
    'name': user.name,
    'currentPassword': currentUserPassword,
    'newEmail': user.email,
    'newPermissions': dbRoles
  };

  // Only send a new password if it is given in the prompt
  if (user.password != "") {
    body["newPassword"] = user.password;
  }

  await ApiManager.put("$url/${user.id}/Credentials", body, await getHeaders())
      .then((value) {
    PopupAndLoading.showSuccess(
        "Gebruiker ${isChange ? "wijzigen" : "toevoegen"} gelukt");
    reloadPage();
  }).catchError((error) {
    PopupAndLoading.showError(
        "Gebruiker ${isChange ? "wijzigen" : "toevoegen"} mislukt");
  });
  PopupAndLoading.endLoading();
}
