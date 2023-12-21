import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/stock.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Stock/stockReport.dart';
import 'package:ms18_applicatie/Users/widgets.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/inputPopup.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => UserListState();
}

class UserListState extends State<UserList> {
  static const String url = "api/v1/User";

  Future<List<User>> getUsers() async {
    List<User> userList = [];

    await ApiManager.get<List<dynamic>>(url).then((data) {
      for (Map<String, dynamic> apiUser in data) {
        User tempUser = User(
            firstName: apiUser["name"],
            lastName: "",
            email: apiUser["email"],
            hashedPassword: "",
            dateOfBirth: DateTime.now(),
            gender: true);
        userList.add(tempUser);
      }
    });

    return userList;
  }

  final List<User> userListFromApi = [
    User(
      firstName: "Frans",
      lastName: "Dijkstra",
      email: "fdijkstra@kpnlive.nl",
      hashedPassword: "hashedPassword",
      dateOfBirth: DateTime.now(),
      gender: true,
    ),
    User(
      firstName: "Gert",
      lastName: "Jansen",
      email: "gert.jansen5362@outlook.com",
      hashedPassword: "hashedPassword",
      dateOfBirth: DateTime.now(),
      gender: true,
    ),
    User(
      firstName: "Marieke",
      lastName: "Naaktgeboren",
      email: "mariemarie35@gmail.com",
      hashedPassword: "hashedPassword",
      dateOfBirth: DateTime.now(),
      gender: true,
    ),
  ];

  Future addUser() async {
    await showInputPopup(
      context,
      title: "Gebruiker toevoegen",
      child: const UserForm(),
      onSave: () {},
      height: 350,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
        child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageHeader(
            title: "Gebruiker beheer",
            onAdd: () {
              addUser();
            },
          ),
          FutureBuilder(
              future: getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Er is iets misgegaan");
                } else if (snapshot.hasData) {
                  List<User> users = snapshot.data ?? [];
                  return Flexible(
                      child: ListView.separated(
                    padding: const EdgeInsets.all(mobilePadding),
                    shrinkWrap: true,
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return UserElement(
                        user: users[index],
                      );
                    },
                  ));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    ));
  }
}
