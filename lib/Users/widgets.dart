import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Widgets/profilePicture.dart';

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
