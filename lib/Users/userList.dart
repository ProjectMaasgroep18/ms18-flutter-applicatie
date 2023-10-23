import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Users/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => UserListState();
}

class UserListState extends State<UserList> {
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

  @override
  Widget build(BuildContext context) {
    return Menu(
        child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageHeader(title: "Gebruiker beheer", onAdd: (){},),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.all(mobilePadding),
              shrinkWrap: true,
              itemCount: userListFromApi.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return UserElement(
                  user: userListFromApi[index],
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
