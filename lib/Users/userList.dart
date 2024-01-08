import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Users/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

import '../Widgets/search.dart';
import 'functions.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => UserListState();
}

class UserListState extends State<UserList> {

  ValueNotifier<String> searchNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
        "Gebruikers beheer",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
        child: SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageHeader(
            onSearch: (value) {
              searchNotifier.value = value;
            },
            onAdd: () {
              addUsersDialog(context, (user) async {
                await addUser(user, context);
              });
            },
          ),
          FutureBuilder(
              future: getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Expanded(
                    child: Center(
                      child: Icon(
                        Icons.error,
                        color: dangerColor,
                        size: 50,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  List<User> users = snapshot.data ?? [];
                  return Flexible(
                      child: Search<User>(
                    searchValue: searchNotifier,
                    items: users,
                    getSearchValue: (item) => item.name,
                    builder: (items) => ListView.separated(
                        padding: const EdgeInsets.all(mobilePadding)
                            .copyWith(top: 0),
                        shrinkWrap: true,
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return UserElement(
                              user: items[index],
                              onDelete: () async {
                                await deleteUser(items[index].id);
                              },
                              onSave: (user) async {
                                await updateUser(user, context);
                              });
                        }),
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
