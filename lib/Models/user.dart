import 'package:ms18_applicatie/roles.dart';

class User {
  int id;
  String name;
  String email;
  String password;
  Roles role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role
  });
}
