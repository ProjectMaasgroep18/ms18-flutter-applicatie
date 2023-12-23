import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Users/widgets.dart';
import 'package:ms18_applicatie/Widgets/pageHeader.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => UserListState();
}

class UserListState extends State<UserList> {
  static const String url = "api/v1/User";

  void reloadPage() {
    navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: ((context) => const UserList())));
  }

  Future<List<User>> getUsers() async {
    List<User> userList = [];
    await ApiManager.get<List<dynamic>>(url).then((data) {
      for (Map<String, dynamic> apiUser in data) {
        User tempUser = User(
            id: apiUser["id"],
            name: apiUser["name"],
            email: apiUser["email"]?? "",
            hashedPassword: "",
            guest: false);
        userList.add(tempUser);
      }
    });
    return userList;
  }

  Future addUser(User user) async {
    Map<String, dynamic> body = {'name': user.name};
    PopupAndLoading.showLoading();
    await ApiManager.post(url, body).then((value) {
      PopupAndLoading.showSuccess("Gebruiker toevoegen gelukt");
      reloadPage();
    }).catchError((error) {
      PopupAndLoading.showError("Gebruiker toevoegen mislukt");
    });
    PopupAndLoading.endLoading();
  }

  Future deleteUser(int userID) async {
    await ApiManager.delete("$url/$userID").then((value) {
      PopupAndLoading.showSuccess("Gebruiker verwijderen gelukt");
      reloadPage();
    }).catchError((error) {
      PopupAndLoading.showError("Gebruiker verwijderen mislukt");
    });
    PopupAndLoading.endLoading();
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
              addUsersDialog(context, (user) async {
                await addUser(user);
              });
            },
          ),
          FutureBuilder(
              future: getUsers(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Er is iets misgegaan");
                } else if (snapshot.hasData)  {
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
                        onDelete: () async {await deleteUser(users[index].id);print("delte");},
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
