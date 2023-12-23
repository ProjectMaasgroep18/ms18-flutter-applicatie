import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Users/userList.dart';
import 'package:ms18_applicatie/Users/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/apiManager.dart';
import '../Models/user.dart';
import '../Widgets/popups.dart';
import '../config.dart';

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
      User tempUser = User(
          id: apiUser["id"],
          name: apiUser["name"],
          email: apiUser["email"] ?? "",
          password: "",
          guest: false);
      userList.add(tempUser);
    }
  });
  return userList;
}

Future addUser(User user) async {
  Map<String, dynamic> body = {'name': user.name};
  PopupAndLoading.showLoading();
  await ApiManager.post(url, body, await getHeaders()).then((value) {
    PopupAndLoading.showSuccess("Gebruiker toevoegen gelukt");
    reloadPage();
  }).catchError((error) {
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

Future updateUser(User user, BuildContext context) async {

  // Ask for confirmation via password
  String currentUserPassword = await askPasswordConfirmation(context) ?? "";

  Map<String, dynamic> body = {
    'name': user.name,
    'currentPassword': "123456",
    'newEmail': user.email,
    'newPassword': user.password,
    'newPermissions': ['admin']
  };
  await ApiManager.put("$url/${user.id}/Credentials", body, await getHeaders())
      .then((value) {
    PopupAndLoading.showSuccess("Gebruiker wijzigen gelukt");
    reloadPage();
  }).catchError((error) {
    PopupAndLoading.showError("Gebruiker wijzigen mislukt");
  });
  PopupAndLoading.endLoading();
}
